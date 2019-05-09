require "./opus"

module Discord
  # An encoder for encoding PCM [Pulse-code modulation](https://en.wikipedia.org/wiki/Pulse-code_modulation) into Opus packets.
  #
  # Example of encoding a sine wave beep sound:
  # ```
  # ```
  class OpusEncoder # structs can't have finalizers because they are not tracked by the GC
    # The coding mode.
    enum Mode
      # Gives best quality for voice signals.
      # It enhances the input signal by high-pass filtering and emphasizing formants and harmonics.
      VoIP = 2048

      # Gives best quality for most non-voice signals like music.
      # Use this mode for music and mixed (music/voice) content and broadcasting.
      Audio = 2049

      # Not recommended. Disables the speech-optimized mode in exchange for slightly reduced delay.
      # Should only be used when lowest-achievable latency is what matters most.
      LowDelay = 2051
    end

    # Creates a new `Encoder`.
    # *channels* needs to be either 1 or 2 (mono or stereo).
    def initialize(mode : Mode = Mode::VoIP, channels : Int32 = 2)
      if channels != 1 && channels != 2
        raise "Invalid channels: #{channels}. The channels needs to be either 1 or 2."
      end

      sample_rate = 48_000
      @encoder = Opus.opus_encoder_create(sample_rate, channels, mode, out error_code)

      if error_code != 0
        error("Error creating encoder", error_code)
      end

      @mode = mode
      @channels = channels
      self.bitrate = 64_000
    end

    getter mode, channels, bitrate

    private def error(message, error_code)
      error_string = String.new(Opus.opus_strerror(error_code))
      raise "#{message}: #{error_string} (code #{error_code})"
    end

    # Sets the bitrate to *bitrate*.
    #
    # *bitrate* needs to be given as bits per second and needs to be between 8kbps and 96kbps.
    def bitrate=(bitrate : Int32)
      if !(8000..96_000).includes?(bitrate)
        raise "Bitrate out of range: #{bitrate}. Bitrate needs to be in the range 8000 to 96,000"
      end

      error_code = Opus.opus_encoder_ctl(@encoder, Opus::OPUS_SET_BITRATE_REQUEST, bitrate)

      if error_code != 0
        error("Error setting bitrate", error_code)
      end

      @bitrate = bitrate
    end

    # TODO: this does not work
    # Sets the coding mode to *mode*.
    def mode=(mode : Mode)
      sample_rate = 48_000
      error_code = Opus.opus_encoder_init(@encoder, sample_rate, @channels, mode: mode)

      if error_code != 0
        error("Error setting mode", error_code)
      end

      @mode = mode
    end

    # TODO: this does not work
    # Sets the audio channels to *channels*.
    # *channels* can only be either 1 or 2 (mono or stereo).
    def channels=(channels : Int32)
      if channels != 1 && channels != 2
        raise "Invalid channels: #{channels}. The channels need to be 1 or 2."
      end

      sample_rate = 48_000
      error_code = Opus.opus_encoder_init(@encoder, sample_rate, @channels, mode)

      if error_code != 0
        error("Error setting channels", error_code)
      end

      @channels = channels
    end

    # Encodes *pcm* into an Opus packet.
    def encode(pcm : Array(Float32)) : Bytes
      data = Bytes.new(pcm.size)

      packet_length = Opus.opus_encode_float(@encoder, pcm, frame_size: 960, data: data, max_data_bytes: 1920)

      if packet_length < 0
        error("Error encoding float PCM array", error_code: packet_length)
      end

      Bytes.new(packet_length) { |i| data[i] }
    end

    # :ditto:
    def encode(pcm : Array(Int16)) : Bytes
      data = Bytes.new(pcm.size)

      packet_length = Opus.opus_encode(@encoder, pcm, frame_size: 960, data: data, max_data_bytes: 1920)

      if packet_length < 0
        error("Error encoding integer PCM array", error_code: packet_length)
      end

      Bytes.new(packet_length) { |i| data[i] }
    end

    # :nodoc:
    def finalize
      puts "COLLECTING GARBAGE"
      Opus.opus_encoder_destroy(@encoder)
    end
  end
end
