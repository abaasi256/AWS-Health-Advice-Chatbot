import voiceService from '../services/voiceService';

// Test Voice Service Functionality
describe('Voice Service', () => {
  beforeEach(() => {
    // Mock Web APIs
    global.MediaRecorder = jest.fn().mockImplementation(() => ({
      start: jest.fn(),
      stop: jest.fn(),
      addEventListener: jest.fn(),
      removeEventListener: jest.fn(),
    }));

    global.speechSynthesis = {
      speak: jest.fn(),
      cancel: jest.fn(),
      getVoices: jest.fn().mockReturnValue([]),
      speaking: false,
    };

    global.navigator.mediaDevices = {
      getUserMedia: jest.fn().mockResolvedValue({}),
    };
  });

  test('should check browser support correctly', () => {
    const support = voiceService.getSupportStatus();
    expect(support).toHaveProperty('recording');
    expect(support).toHaveProperty('synthesis');
    expect(support).toHaveProperty('full');
  });

  test('should handle text-to-speech', async () => {
    const testText = 'Hello, this is a test message';
    
    // Mock successful speech
    global.speechSynthesis.speak = jest.fn();
    
    await expect(voiceService.speak(testText)).resolves.not.toThrow();
  });

  test('should get available voices', () => {
    const mockVoices = [
      { name: 'Google US English', lang: 'en-US' },
      { name: 'Google UK English', lang: 'en-GB' }
    ];
    
    global.speechSynthesis.getVoices = jest.fn().mockReturnValue(mockVoices);
    
    const voices = voiceService.getAvailableVoices();
    expect(voices).toEqual(mockVoices);
  });

  test('should handle recording state', () => {
    expect(voiceService.getIsRecording()).toBe(false);
    expect(voiceService.getIsSpeaking()).toBe(false);
  });
});
