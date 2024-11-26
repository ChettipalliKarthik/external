import socket

def run_client():
    try:
        # Create a socket object
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        server_ip = "127.0.0.1"  # Replace with the server's IP address
        server_port = 8000  # Replace with the server's port number

        # Establish connection with the server
        print("Connecting to server...")
        client.connect((server_ip, server_port))
        print("Connected to the server.")

        while True:
            # Input message and send it to the server
            msg = input("Enter message ('exit' to quit): ").strip()
            if not msg:  # Prevent sending empty messages
                print("Empty message! Please enter a valid message.")
                continue

            if msg.lower() == "exit":  # Allow client to exit
                print("Exiting...")
                client.send(msg.encode("utf-8"))
                break

            client.send(msg.encode("utf-8"))

            # Receive message from the server
            response = client.recv(1024).decode("utf-8")
            print(f"Received: {response}")

            # If server sends "closed", terminate the connection
            if response.lower() == "closed":
                print("Server closed the connection.")
                break

    except ConnectionRefusedError:
        print("Error: Could not connect to the server. Make sure the server is running.")
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Close client socket (connection to the server)
        client.close()
        print("Connection to server closed.")

# Run the client
if __name__ == "__main__":
    run_client()
