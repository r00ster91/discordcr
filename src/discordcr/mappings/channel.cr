require "./converters"

module Discord
  struct Message
    JSON.mapping(
      type: {type: UInt8, nilable: true},
      content: String,
      id: {type: UInt64, converter: SnowflakeConverter},
      channel_id: {type: UInt64, converter: SnowflakeConverter},
      author: User,
      timestamp: {type: Time, converter: Time::Format::ISO_8601_DATE},
      tts: Bool,
      mention_everyone: Bool,
      mentions: Array(User),
      mention_roles: {type: Array(UInt64), converter: SnowflakeArrayConverter},
      attachments: Array(Attachment),
      embeds: Array(Embed),
      nonce: {type: UInt64?, converter: MaybeSnowflakeConverter},
      pinned: {type: Bool, nilable: true}
    )
  end

  struct Channel
    JSON.mapping(
      id: {type: UInt64, converter: SnowflakeConverter},
      type: UInt8,
      guild_id: {type: UInt64?, converter: MaybeSnowflakeConverter},
      name: {type: String, nilable: true},
      is_private: {type: Bool, nilable: true},
      permission_overwrites: {type: Array(Overwrite), nilable: true},
      topic: {type: String, nilable: true},
      last_message_id: {type: UInt64?, converter: MaybeSnowflakeConverter},
      bitrate: {type: UInt32, nilable: true},
      user_limit: {type: UInt32, nilable: true},
      recipients: {type: Array(User), nilable: true}
    )
  end

  struct PrivateChannel
    JSON.mapping(
      id: {type: UInt64, converter: SnowflakeConverter},
      type: UInt8,
      recipients: Array(User),
      last_message_id: UInt64
    )
  end

  struct Overwrite
    JSON.mapping(
      id: {type: UInt64, converter: SnowflakeConverter},
      type: String,
      allow: UInt64,
      deny: UInt64
    )
  end

  struct Embed
    JSON.mapping(
      title: {type: String, nilable: true},
      type: String,
      description: {type: String, nilable: true},
      url: String,
      thumbnail: {type: EmbedThumbnail, nilable: true},
      provider: {type: EmbedProvider, nilable: true}
    )
  end

  struct EmbedThumbnail
    JSON.mapping(
      url: String,
      proxy_url: String,
      height: UInt32,
      width: UInt32
    )
  end

  struct EmbedProvider
    JSON.mapping(
      name: String,
      url: String
    )
  end

  struct Attachment
    JSON.mapping(
      id: {type: UInt64, converter: SnowflakeConverter},
      filename: String,
      size: UInt32,
      url: String,
      proxy_url: String,
      height: {type: UInt32, nilable: true},
      width: {type: UInt32, nilable: true}
    )
  end
end
