import socket

def run_server():
    # Create a socket object
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # Define server IP and port
    server_ip = "127.0.0.1"  # Use "0.0.0.0" for network access
    port = 8000

    try:
        # Bind the socket to a specific address and port
        server.bind((server_ip, port))
        # Listen for incoming connections (maximum queue size 5)
        server.listen(5)
        print(f"Listening on {server_ip}:{port}")

        # Accept incoming connections
        client_socket, client_address = server.accept()
        print(f"Accepted connection from {client_address[0]}:{client_address[1]}")

        # Receive data from the client
        while True:
            try:
                # Receive and decode the client's request
                request = client_socket.recv(1024).decode("utf-8")

                # If the client sends "close", acknowledge and close the connection
                if request.lower() == "close":
                    client_socket.send("closed".encode("utf-8"))
                    print("Closing connection as requested by client.")
                    break

                print(f"Received: {request}")

                # Send a response back to the client
                response = "accepted".encode("utf-8")
                client_socket.send(response)

            except ConnectionResetError:
                print("Client disconnected unexpectedly.")
                break

    except Exception as e:
        print(f"An error occurred: {e}")

    finally:
        # Ensure sockets are closed properly
        client_socket.close()
        server.close()
        print("Server shut down.")

# Run the server
if __name__ == "__main__":
    run_server()
