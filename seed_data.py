from tarantool import Connection

conn = Connection("localhost", 3302)

conn.insert("user", (None,'a',1, ))
conn.insert("user", (None,'b',1, ))
conn.insert("user", (None,'a',0, ))
conn.insert("user", (None,'b',0, ))

conn.insert("channel", (None,'1001373637514', 1, 't.me/ofka'))
conn.insert("channel", (None,'1236565135464', 1, 't.me/root'))
conn.insert("channel", (None,'icqchannel1', 0, 'icq.com/qwe'))
conn.insert("channel", (None,'icqchannel2', 0, 'icq.com/zxcvbnm'))

conn.insert("link", (None, 1, 3, 1))
conn.insert("link", (None, 2, 3, 1))
conn.insert("link", (None, 2, 4, 2))