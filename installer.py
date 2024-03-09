import subprocess
import os
import time

def run_script(script_path):
    result = subprocess.run([script_path])
    return result

def get_option2(text):
    exit = False
    while not exit:
        
        o = input(str(text + " (number): "))
        if o.isdigit() and 1 <= int(o) <= 5:
            exit = True
            return int(o)
        else:
            print("Invalid option, please enter a number between 1 and 5")

def print_menu():
    print("1. Install ros2")
    print("2. Install kobuki")
    print("3. Install netgui")
    print("4. Install rars")
    print("5. Exit")

def get_option(text):
    exit = False
    while not exit:
        o = input(str(text + " (y/n): "))
        if o == "y" or o == "n" or o == "":
            exit = True
            return o.lower()
        else:
            print("Invalid option, please enter 'y' or 'n'")

def main():

    # First I need to add EIF repository
    print("")
    print("------------------------------------------------------------")
    print("--- Welcome to the installation script of EIF linux apps ---")
    print("------------------------------------------------------------")
    print("")

    try:

        option = get_option("--- First I need to install EIF repository")

        if (option == "y" or option == ""):
            
            print("")
            print("Installing eif repo ... ")
            print("")

            cmd_exit = run_script("./scripts/eif_repo_install.sh")

            # print(f"Script exited with status {cmd_exit.returncode}")
            print("")
            print("Finished installing eif repo.")
            print("")

            print("--- Now you can select what to install ---")
        
        else:
            print("")
            print(" --- Good bye :), see you next time --- ")
            print("")
            exit = True


        exit = False
        while not exit:

            print("")
            print_menu()
            option2 = get_option2("Please select what to install")

            if option2 == 5:
                exit = True
                print("")
                print(" ---  User exited the program --- ")
                print(" --- Good bye :), see you next time --- ")
                print("")

            elif option2 == 1:
                print("")
                print("Installing ros2 ... ")
                print("")
                script_exit = run_script("./scripts/install_ros2.sh")
                print("")
                print("Finished installing ros2.")
                print("")

            elif option2 == 2:
                print("")
                print("Installing kobuki ... ")
                print("")
                script_exit = run_script("./scripts/install_kobuki.sh")

                print("")
                print("Finished installing kobuki.")
                print("")

            elif option2 == 3:
                print("")
                print("Installing netgui ... ")
                print("")
                script_exit = run_script("./scripts/install_netgui.sh")
                print("")
                print("Finished installing netgui.")
                print("")
            
            if script_exit == 0:
                print("")
                print("Installation finished successfully.")
            else:
                print("")
                print("Installation failed.")





        #print(os.environ['patatacaliente'])

        # Get the value of an environment variable
        #print(os.environ['HOME'])

        #print(os.environ['patata'])

        # Set the value of an environment variable
        #os.environ['balon'] = 'test'

        # Get the value of the variable we just set
        #print(os.environ['balon'])

        #run_script("./scripts/explain.sh")


        # while True:
            #print_menu()
            #choice = input("Enter your choice: ")
            
            # if choice == "1":
            #     run_script("install1.sh")
            # elif choice == "2":
            #     run_script("install2.sh")
            # elif choice == "3":
            #     run_script("install3.sh")
            # elif choice == "4":
            #     break
            # else:
            #     print("Invalid choice. Please enter a number between 1 and 4.")
        
    except KeyboardInterrupt:
        print("")
        print(" --- The user force the program exit --- ")
        print(" --- Good bye :), see you next time --- ")
        print("")
        

if __name__ == "__main__":
    main()