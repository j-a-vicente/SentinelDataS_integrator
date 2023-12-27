from binascii import b2a_hex

class util:
    def sid_to_str(sid):

        try:
            # Python 3
            if str is not bytes:
                # revision
                revision = int(sid[0])
                # count of sub authorities
                sub_authorities = int(sid[1])
                # big endian
                identifier_authority = int.from_bytes(sid[2:8], byteorder='big')
                # If true then it is represented in hex
                if identifier_authority >= 2 ** 32:
                    identifier_authority = hex(identifier_authority)

                # loop over the count of small endians
                sub_authority = '-' + '-'.join([str(int.from_bytes(sid[8 + (i * 4): 12 + (i * 4)], byteorder='little')) for i in range(sub_authorities)])
            # Python 2
            else:
                revision = int(b2a_hex(sid[0]))
                sub_authorities = int(b2a_hex(sid[1]))
                identifier_authority = int(b2a_hex(sid[2:8]), 16)
                if identifier_authority >= 2 ** 32:
                    identifier_authority = hex(identifier_authority)

                sub_authority = '-' + '-'.join([str(int(b2a_hex(sid[11 + (i * 4): 7 + (i * 4): -1]), 16)) for i in range(sub_authorities)])
            objectSid = 'S-' + str(revision) + '-' + str(identifier_authority) + sub_authority

            return objectSid
        except Exception:
            pass

        return sid

if __name__ == "__main__":
    sid = b'\x01\x05\x00\x00\x00\x00\x00\x05\x15\x00\x00\x00\x9dMu\x02=\r\x00+n?|F\xb3\x97\x01\x00'
    print(util.sid_to_str(sid))  # S-1-5-21-2562418665-3218585558-1813906818-1576