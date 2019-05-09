module Discord
  @[Link("opus")]
  lib Opus
    type OpusEncoder = Void

    alias OpusInt16 = Int16
    alias OpusInt32 = Int32

    enum Application
      OPUS_APPLICATION_VOIP                = 2048
      OPUS_APPLICATION_AUDIO               = 2049
      OPUS_APPLICATION_RESTRICTED_LOWDELAY = 2051
    end

    OPUS_SET_BITRATE_REQUEST = 4002

    fun opus_encoder_create(fs : OpusInt32,
                            channels : LibC::Int,
                            application : LibC::Int,
                            error : LibC::Int*) : OpusEncoder*

    fun opus_encoder_destroy(st : OpusEncoder*)

    fun opus_encode(st : OpusEncoder*,
                    pcm : OpusInt16*,
                    frame_size : LibC::Int,
                    data : LibC::UChar*,
                    max_data_bytes : OpusInt32) : OpusInt32

    fun opus_encode_float(st : OpusEncoder*,
                          pcm : LibC::Float*,
                          frame_size : LibC::Int,
                          data : LibC::UChar*,
                          max_data_bytes : OpusInt32) : OpusInt32

    fun opus_strerror(error : LibC::Int) : LibC::Char*

    fun opus_encoder_get_size(channels : LibC::Int) : LibC::Int

    fun opus_encoder_init(st : OpusEncoder*,
                          fs : OpusInt32,
                          channels : LibC::Int,
                          application : LibC::Int) : LibC::Int

    fun opus_encoder_ctl(st : OpusEncoder*,
                         request : LibC::Int,
                         ...) : LibC::Int
  end
end
