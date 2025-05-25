import { APP_CONFIG } from '../config';

class VoiceService {
  constructor() {
    this.isRecording = false;
    this.mediaRecorder = null;
    this.audioChunks = [];
    this.stream = null;
    this.speechSynthesis = window.speechSynthesis;
    this.isSupported = this.checkSupport();
  }

  checkSupport() {
    const hasMediaRecorder = typeof MediaRecorder !== 'undefined';
    const hasGetUserMedia = navigator.mediaDevices && navigator.mediaDevices.getUserMedia;
    const hasSpeechSynthesis = 'speechSynthesis' in window;

    return {
      recording: hasMediaRecorder && hasGetUserMedia,
      synthesis: hasSpeechSynthesis,
      full: hasMediaRecorder && hasGetUserMedia && hasSpeechSynthesis
    };
  }

  async startRecording() {
    if (!this.isSupported.recording) {
      throw new Error('Audio recording is not supported in this browser');
    }

    if (this.isRecording) {
      console.warn('Recording is already in progress');
      return;
    }

    try {
      this.stream = await navigator.mediaDevices.getUserMedia({
        audio: {
          echoCancellation: true,
          noiseSuppression: true,
          autoGainControl: true,
          sampleRate: 16000
        }
      });

      const options = {
        mimeType: this.getSupportedMimeType(),
        audioBitsPerSecond: 16000
      };

      this.mediaRecorder = new MediaRecorder(this.stream, options);
      this.audioChunks = [];

      this.mediaRecorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          this.audioChunks.push(event.data);
        }
      };

      this.mediaRecorder.onstop = () => {
        console.log('Recording stopped');
      };

      this.mediaRecorder.onerror = (event) => {
        console.error('MediaRecorder error:', event.error);
      };

      this.mediaRecorder.start(100);
      this.isRecording = true;

      console.log('Recording started');
    } catch (error) {
      console.error('Error starting recording:', error);
      throw new Error('Failed to start recording. Please check microphone permissions.');
    }
  }

  async stopRecording() {
    if (!this.isRecording || !this.mediaRecorder) {
      throw new Error('No recording in progress');
    }

    return new Promise((resolve, reject) => {
      this.mediaRecorder.onstop = () => {
        try {
          const audioBlob = new Blob(this.audioChunks, {
            type: this.getSupportedMimeType()
          });

          this.cleanupRecording();

          console.log('Recording completed, blob size:', audioBlob.size);
          resolve(audioBlob);
        } catch (error) {
          reject(error);
        }
      };

      this.mediaRecorder.stop();
      this.isRecording = false;
    });
  }

  cancelRecording() {
    if (this.isRecording && this.mediaRecorder) {
      this.mediaRecorder.stop();
      this.isRecording = false;
      this.cleanupRecording();
      console.log('Recording cancelled');
    }
  }

  cleanupRecording() {
    if (this.stream) {
      this.stream.getTracks().forEach(track => track.stop());
      this.stream = null;
    }
    this.mediaRecorder = null;
    this.audioChunks = [];
  }

  getSupportedMimeType() {
    const types = [
      'audio/webm;codecs=opus',
      'audio/webm',
      'audio/mp4',
      'audio/wav'
    ];

    for (const type of types) {
      if (MediaRecorder.isTypeSupported(type)) {
        return type;
      }
    }

    return 'audio/webm';
  }

  async speak(text, options = {}) {
    if (!this.isSupported.synthesis) {
      console.warn('Speech synthesis is not supported in this browser');
      return;
    }

    this.speechSynthesis.cancel();

    return new Promise((resolve, reject) => {
      const utterance = new SpeechSynthesisUtterance(text);

      utterance.rate = options.rate || APP_CONFIG.voice.speechRate;
      utterance.pitch = options.pitch || APP_CONFIG.voice.speechPitch;
      utterance.volume = options.volume || APP_CONFIG.voice.speechVolume;
      utterance.lang = options.language || APP_CONFIG.voice.language;

      const voices = this.speechSynthesis.getVoices();
      const preferredVoice = voices.find(voice => 
        voice.lang.startsWith('en') && voice.name.includes('Google')
      ) || voices.find(voice => voice.lang.startsWith('en'));

      if (preferredVoice) {
        utterance.voice = preferredVoice;
      }

      utterance.onend = () => {
        console.log('Speech synthesis completed');
        resolve();
      };

      utterance.onerror = (event) => {
        console.error('Speech synthesis error:', event.error);
        reject(new Error(`Speech synthesis failed: ${event.error}`));
      };

      this.speechSynthesis.speak(utterance);
    });
  }

  stopSpeaking() {
    if (this.speechSynthesis.speaking) {
      this.speechSynthesis.cancel();
      console.log('Speech synthesis cancelled');
    }
  }

  async playAudio(audioSource) {
    return new Promise((resolve, reject) => {
      const audio = new Audio();
      
      if (audioSource instanceof Blob) {
        audio.src = URL.createObjectURL(audioSource);
      } else if (typeof audioSource === 'string') {
        audio.src = audioSource;
      } else {
        reject(new Error('Invalid audio source'));
        return;
      }

      audio.onended = () => {
        if (audioSource instanceof Blob) {
          URL.revokeObjectURL(audio.src);
        }
        resolve();
      };

      audio.onerror = () => {
        if (audioSource instanceof Blob) {
          URL.revokeObjectURL(audio.src);
        }
        reject(new Error('Failed to play audio'));
      };

      audio.play().catch(reject);
    });
  }

  getAvailableVoices() {
    if (!this.isSupported.synthesis) {
      return [];
    }

    return this.speechSynthesis.getVoices();
  }

  getIsRecording() {
    return this.isRecording;
  }

  getIsSpeaking() {
    return this.speechSynthesis.speaking;
  }

  getSupportStatus() {
    return this.isSupported;
  }
}

const voiceService = new VoiceService();
export default voiceService;