from tarantool import Connection
from transfer_data import TransferData

conn = Connection("localhost", 3302)

data = TransferData(conn)
data.transfer()

result_transfer = conn.select("links", )
print(result_transfer)