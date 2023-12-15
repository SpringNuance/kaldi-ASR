cd tools

sudo apt-get install dos2unix

dos2unix extras/check_dependencies.sh
chmod +x extras/check_dependencies.sh
extras/check_dependencies.sh

sudo apt-get update
sudo apt-get install python2.7
sudo apt-get install sox
sudo apt-get install subversion
sudo apt-get install gfortran
sudo apt-get install unzip


chmod +x extras/install_mkl.sh
dos2unix extras/install_mkl.sh
extras/install_mkl.sh

# install g++ -4.8 on Ubuntu 20.8
cd - 
chmod +x install_gpp48.sh
dos2unix install_gpp48.sh
./install_gpp48.sh

cd tools
make -j 4

chmod +x extras/install_irstlm.sh
dos2unix extras/install_irstlm.sh
extras/install_irstlm.sh

cd src
chmod +x configure
dos2unix configure
./configure  
make depend  

dos2unix src/.version

# note: very long time to compile
make -j 4

