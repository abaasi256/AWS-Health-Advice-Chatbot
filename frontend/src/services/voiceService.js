import { APP_CONFIG } from '../config';

class VoiceService {
  constructor() {
    this.isRecording = false;
    this.mediaRecorder = null;
    this.audioChunks = [];
    this.stream = null;
    this.speechSynthesis = window.speechSynthesis;
    this.isSupported = this.checkSupport();
    
    // Ensure voices are loaded
    this.ensureVoicesLoaded();
  }

  checkSupport() {
    const hasMediaRecorder = typeof MediaRecorder !== 'undefined';
    const hasGetUserMedia = navigator.mediaDevices && navigator.mediaDevices.getUserMedia;
    const hasSpeechSynthesis = 'speechSynthesis' in window;
    
    // Additional check for speech synthesis functionality
    const speechSynthesisWorking = hasSpeechSynthesis && 
      typeof window.speechSynthesis.speak === 'function';

    return {
      recording: hasMediaRecorder && hasGetUserMedia,
      synthesis: speechSynthesisWorking,
      full: hasMediaRecorder && hasGetUserMedia && speechSynthesisWorking
    };
  }

  async ensureVoicesLoaded() {
    if (!this.speechSynthesis) return;
    
    return new Promise((resolve) => {
      const checkVoices = () => {
        const voices = this.speechSynthesis.getVoices();
        if (voices.length > 0) {
          resolve(voices);
        } else {
          // Wait for voices to load
          this.speechSynthesis.addEventListener('voiceschanged', () => {
            resolve(this.speechSynthesis.getVoices());
          }, { once: true });
          
          // Fallback timeout
          setTimeout(() => resolve([]), 2000);
        }
      };
      
      checkVoices();
    });
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
      throw new Error('Text-to-speech is not supported in this browser');
    }

    // Cancel any ongoing speech
    this.speechSynthesis.cancel();
    
    // Small delay to ensure cancellation is processed
    await new Promise(resolve => setTimeout(resolve, 50));

    return new Promise((resolve, reject) => {
      try {
        const utterance = new SpeechSynthesisUtterance(text);

        utterance.rate = options.rate || APP_CONFIG.voice.speechRate;
        utterance.pitch = options.pitch || APP_CONFIG.voice.speechPitch;
        utterance.volume = options.volume || APP_CONFIG.voice.speechVolume;
        utterance.lang = options.language || APP_CONFIG.voice.language;

        // Get and set voice
        const voices = this.speechSynthesis.getVoices();
        if (voices.length > 0) {
          const preferredVoice = voices.find(voice => 
            voice.lang.startsWith('en') && (
              voice.name.includes('Google') || 
              voice.name.includes('Microsoft') ||
              voice.name.includes('Amazon')
            )
          ) || voices.find(voice => voice.lang.startsWith('en')) || voices[0];

          if (preferredVoice) {
            utterance.voice = preferredVoice;
          }
        }

        utterance.onend = () => {
          console.log('Speech synthesis completed');
          resolve();
        };

        utterance.onerror = (event) => {
          console.error('Speech synthesis error:', event.error);
          reject(new Error(`Speech synthesis failed: ${event.error}`));
        };

        // Start speaking
        this.speechSynthesis.speak(utterance);
        
        // Fallback for some browsers that don't fire events properly
        setTimeout(() => {
          if (this.speechSynthesis.speaking) {
            console.log('Speech synthesis started successfully');
          } else {
            reject(new Error('Speech synthesis failed to start'));
          }
        }, 100);
        
      } catch (error) {
        console.error('Error creating speech utterance:', error);
        reject(error);
      }
    });
  }

  stopSpeaking() {
    if (this.speechSynthesis && this.speechSynthesis.speaking) {
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
    return this.speechSynthesis && this.speechSynthesis.speaking;
  }

  getSupportStatus() {
    return this.isSupported;
  }

  // Test speech synthesis
  async testSpeak() {
    try {
      await this.speak('Test', { volume: 0.1 });
      return true;
    } catch (error) {
      console.error('Speech test failed:', error);
      return false;
    }
  }
}

const voiceService = new VoiceService();
export default voiceService;
