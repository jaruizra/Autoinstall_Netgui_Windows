# Autoinstall_Netgui_Windows
This is a guide to install and use netgui and Wireshark in windows, it has automatic .bat install files and it is pain-free. It uses windows WSL2.
It installs all the necessary repositories and packages to run netgui and Wireshark on Ubuntu 22.04 on wsl2.

RUN LINUX APPS ON WINDOWS !!!

![Captura de pantalla 2023-06-05 204228](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/36ba3257-ea16-4e7b-b640-1b929eb7312a)


# From the beginning
![ubuntu-20 4-wsl](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/5990a78d-a81f-49d4-8855-3e81bb7b48e1)
This uses windows WSL2(windows subsystem for Linux), this is like a virtual machine, however, it is built into windows, and only the Linux kernel. It’s even better, because it is barebone, it does not include almost nothing, is a fresh install of Linux. You can install many distros; however, we will be using Ubuntu 22.04.


# How to install
1.	Enable virtualization in the BIOS (it should be enabled by default) you can check many YouTube videos on how to do it. Here is a guide on how to do this
  
        https://support.bluestacks.com/hc/en-us/articles/360058102252-How-to-enable-Virtualization-VT-on-Windows-10-for-BlueStacks-5
  
2.	Run the **vm_enable.bat** file, it will ask for privilege access, it needs those for install the Windows subsystem for Linux and Virtual Machine Platform characteristics.
         
        Double-click the vm_enable.bat file
        
        (To run a .bat file just double click on it.)

        ¡RESTART THE SYSTEM!

3.	Run the wsl_install.bat file, it will ask also for privilege access, it will install ubuntu and the wsl, it will take some time:
        
        Double-click the wsl_install.bat file
        
        (To run a .bat file just double click on it.)

- It will ask for a username.
- It will ask for a password.

You should see a Linux terminal in the cmd terminal that is opened. If not restart the device and search for ubuntu, a terminal should open. You can close it.

4.	Run the Netgui_install.bat, this will update your ubuntu install, then it will add the URJC EIF repository, it will then install netgui and Wireshark.

        Double-click the Netgui_install.bat file
        
        (To run a .bat file just double click on it.)
        
        it will ask for your Ubuntu created password, type it and wait...
        
        (if it ask for something select always yes)


# How to use netgui 
1.	To open the ubuntu terminal, type on windows search Ubuntu, it will show as a regular windows app, when opened it will show an Ubuntu terminal. All Ubuntu commands will work on it, you can “ls” and modify files with “nano”.
	
![Captura de pantalla 2023-06-05 212458](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/8a6a2361-f08d-43b1-a276-240b8226927b)
![Captura de pantalla 2023-06-05 212651](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/116008b9-0e90-442d-92cc-80782f6ec5c3)


2.	THE MAGIC -> You are using a full-on Linux distro in windows!
3.	You can check the files of Ubuntu from windows, you will see there is a new mounted drive called Linux on your windows file explorer. Just open it and get access to all ubuntu files.
4.	![Captura de pantalla 2023-06-05 212756](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/95637858-1955-4fc9-9a1e-6aba7b267a09)
          
       You can create a file inside Ubuntu/home/"YOUR_USERNAME" called CodeUbuntu where you can save your files, you can pin it to favorites  so you can access it more easily.
       
6.	You can type on the terminal “netgui.sh” to open the netgui app, it should work as usual.

![Captura de pantalla 2023-06-05 213043](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/9c785622-28f1-4eb7-a0d6-418697437ec5)


# How to use Wireshark
![image](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/d875e4c9-89e7-46db-827a-d94b0c7cae57)

Here things are going to go different, we want to use the Linux version that we installed on Ubuntu. So, for that to happen, you can type on Ubuntu terminal “Wireshark” to open and search files. Here are ways to do this.
## 1.	Open Wireshark like a normal windows app 
Do it by searching for Wireshark on windows or type Wireshark on ubuntu terminal, then with the app navigate and locate files and open them.

![Captura de pantalla 2023-06-05 213152](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/0fc5c298-2ac5-4d43-bde0-3914550f58a9)



## 2.	THE BETTER WAY 
! JUST DOUBLE CLICK FILE TO OPEN AUTOMATIC WIRESHARK ¡
![Captura de pantalla 2023-06-05 213717](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/dd103301-09b4-4ffb-b363-5363c1e28193)

We are going to browse the files with windows file explorer, then will assign .cap files (those are the ones created by tcdump) to open with a .bat file we are going to create.
![Captura de pantalla 2023-06-05 213557](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/5171ee96-9073-4087-b7e4-5a9ce0d6595b)
### WHY? -> Because windows don’t let you to select as a default app that is installed in wsl. 
### WHAT IS THE .BAT -> Is a code that uses wslpath to open a command line, then launch Wireshark form ubuntu but it gives the argument of the file path we want to open in a way that Ubuntu gets it, because windows and ubuntu paths are formatted in a different way?
### ISSUES -> If you have a file on a path with blank spaces, it will not work.
          
          This will work: \\wsl.localhost\Ubuntu-22.04
          This will work: C:\Users\javie\Downloads
          This will not work: D:\OneDrive - Universidad Rey Juan Carlos\Escritorio   (ckeck the spaces in the "Universidad rey...")
          
3.	Safe the wireshark_ubuntu.bat file on a safe place, like the documents folder.
4.	Open on windows 11 default apps, and up in the search by type of document type: “.cap”. Select the first option and click on “Select another app from my pc”, then search for the wireshark_ubuntu.bat file on your documents folder. Each time you open a .cap file (tcdump output file) it will open Linux Wireshark. It should work flawlessly.
![Captura de pantalla 2023-06-05 214057](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/8791b7a9-747c-4a8e-af3f-5ef50c8ff677)

![Captura de pantalla 2023-06-05 214225](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/0fd3d8f0-22df-4735-bd39-b9d1d4eee7c1)

![Captura de pantalla 2023-06-05 214324](https://github.com/jaruizra/Autoinstall_Netgui_Windows/assets/121313957/dac4c066-e55c-4b23-9eac-fee3f0d3764c)


# Help
This is a personal project, that has been tested very little time, it will work, or maybe not, however I can assure it will not break window 🤣🤣😂.
You can try it without any issues, it should work just fine.

Good luck ;)
