import socket

from binascii import b2a_hex

from datetime import datetime, timedelta

from datetime import datetime, timedelta, tzinfo

from calendar import timegm





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


    def whenC_to_datetime(whenCreated):
        if whenCreated is not None:
            when_changed_value = whenCreated
            # Remova o "Z" no final e converta para um objeto datetime
            when_changed_datetime = datetime.strptime(when_changed_value[:-1], "%Y%m%d%H%M%S.%f")

            # Exiba a data e hora no formato desejado
            objectWhen = when_changed_datetime.strftime("%Y-%m-%d %H:%M:%S")

            return objectWhen         
        else:
            return '1900-01-01 00:00:00'

    def int_to_datetime(lastLogonTimestamp):
        vr = util.if_null(lastLogonTimestamp)
        if vr != 0 :
            if int(lastLogonTimestamp) != 9223372036854775807:
                # Valor do atributo lastLogonTimestamp do Active Directory
                last_logon_timestamp_value = int(lastLogonTimestamp)

                # Época do Windows (1 de janeiro de 1601)
                windows_epoch = datetime(1601, 1, 1)

                # Converta o valor para segundos (1 segundo = 10^7 nanossegundos)
                seconds_since_windows_epoch = last_logon_timestamp_value / 10**7

                # Crie o objeto datetime adicionando os segundos à época do Windows
                last_logon_datetime = windows_epoch + timedelta(seconds=seconds_since_windows_epoch)

                # Exiba a data e hora no formato desejado
                objectL = last_logon_datetime.strftime("%Y-%m-%d %H:%M:%S")

                return objectL
            else:
                return '1900-01-01 00:00:00'
        else:
            return '1900-01-01 00:00:00'


    def remover_aspas(valor):
         #Remover aspas de dentro do registro.
        if valor is not None:      
            texto = str(valor)
            valor_sem_aspas = texto.replace("'", "")                               
        else:
            valor_sem_aspas = ""      
        
        return valor_sem_aspas

    def conver_int_datetime(raw_date):
        
        try:
            # Get seconds and remainder in terms of Unix epoch
            (s, ns100) = divmod(raw_date - 116444736000000000 , 10000000)
            # Convert to datetime object
            dt = datetime.utcfromtimestamp(s)
            # Add remainder in as microseconds. Python 3.2 requires an integer
            dt = dt.replace(microsecond=(ns100 // 10))
            return dt
        except Exception:
            return '1900-01-01 00:00:00.000'

    def if_null(valor):
        if valor is not None: 
            return valor
        else:
            return 0

    def obter_ip(nome_host):
        try:
            endereco_ip = socket.gethostbyname(nome_host)
            return endereco_ip
        except socket.error as e:
            print(f"Erro ao obter IP para {nome_host}: {e}")
            return None





if __name__ == "__main__":
    #sid = b'\x01\x05\x00\x00\x00\x00\x00\x05\x15\x00\x00\x00\x9dMu\x02=\r\x00+n?|F\xb3\x97\x01\x00'
    #print(util.sid_to_str(sid))  # S-1-5-21-2562418665-3218585558-1813906818-1576
    #whenCreated = "20231228133842.0Z"
    #print(util.whenC_to_datetime(whenCreated))
    #lastLogonTimestamp = 9223372036854775807
    #print(util.int_to_datetime(lastLogonTimestamp))
    #valor = 'aa'
    #vl = util.if_null(valor)
    #print(vl)
    print(util.obter_ip('BE10357525'))
