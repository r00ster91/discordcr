# This simple example bot creates a message whenever a new user joins the server

require "../src/discordcr"

# Make sure to replace this fake data with actual data when running.
client = Discord::Client.new(token: "Bot MjI5NDU5NjgxOTU1NjUyMzM3.Cpnz31.GQ7K9xwZtvC40y8MPY3eTqjEIXm", client_id: 229459681955652337_u64)
cache = Discord::Cache.new(client)
client.cache = cache

client.on_guild_member_add do |payload|
  # Get the guild/server information
  guild = cache.resolve_guild(payload.guild_id.value)

  client.create_message(guild.id.value, "Please welcome <@#{payload.user.id.value}> to #{guild.name}.")
end

client.run
