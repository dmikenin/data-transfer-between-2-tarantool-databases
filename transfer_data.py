from tarantool import Connection
import hashlib


class TransferData:
    def __init__(self, connection):
        self.conn = connection
        self.link_space = self.conn.space('link')
        self.user_space = self.conn.space('user')
        self.channel_space = self.conn.space('channel')
        self.source_last_id = ''
        self.source_type = "tm"

    def gen_uid(self, user_id, source_link, icq_channel):
        arr = [user_id, source_link, icq_channel]
        arr.sort()
        str = "/".join(arr)
        hash_object = hashlib.md5(str.encode())
        return hash_object.hexdigest()

    def get_icq_channel(self, type_id):
        channel_list_for_icq = self.channel_space.select(type_id, index='id')
        icq_channel = ''
        for item_channel_icq in channel_list_for_icq:
            icq_channel = item_channel_icq[3]
        return icq_channel

    def get_user_id(self, link):
        user_current_list = ''
        user_current = self.user_space.select(link, index='id')
        for user_current_item in user_current:
            user_current_list = self.user_space.select(user_current_item[1], index='external_id_type_id')

        user_id = ''
        for item_user in user_current_list:
            if item_user[2] != 0:
                continue
            user_id = item_user[1]
        return user_id

    def get_social_id_and_link(self, channel_id_from):
        channel_item = self.channel_space.select(channel_id_from, index='id')
        for item_parse in channel_item:
            if item_parse[2] != 1:
                continue

            source_id = item_parse[1]
            source_link = item_parse[3]

            return source_id, source_link

    def transfer(self):
        try:
            link_list = self.link_space.select()
            for link in link_list:
                source_id, source_link = self.get_social_id_and_link(link[1])
                icq_channel = self.get_icq_channel(link[2])
                user_id = self.get_user_id(link[3])
                link_id = self.gen_uid(str(link[3]), source_link, icq_channel)

                self.conn.insert("links", (
                source_link, icq_channel, user_id, self.source_last_id, source_id, self.source_type, link_id))
        except Exception as e:
            print('Error transfer', e)
