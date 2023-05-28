%define version 1.4.0
%define debug_package %{nil}
%define __strip /bin/true
%define _prefix /usr

Name:          whispercpp-cublas
Version:       %{version}
Release:       %{relver}%{?date:.%{?date}%{?date:git}%{?rel}}%{?dist}
Summary:       C++ implemetataion of OpenAI's Whisper ASR model
License:       MIT License
Group:         Applications/Multimedia
URL:           https://github.com/ggerganov/whisper.cpp
#Source0:       https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v%{version}.tar.gz
Source0:       https://github.com/ggerganov/whisper.cpp/archive/refs/heads/master.zip
BuildArch:     x86_64
BuildRequires: make cmake wget gcc gcc-c++

%description
High-performance inference of OpenAI's Whisper automatic speech
recognition (ASR) model. Shared library.

%prep
rm -rf %{_sourcedir}
mkdir -p %{_sourcedir}
cd %{_sourcedir}
wget https://github.com/ggerganov/whisper.cpp/archive/refs/heads/master.tar.gz
tar -xzf master.tar.gz --strip-components 1 -C %{_builddir}

%build
mkdir -p %{_builddir}/target
cd %{_builddir}/target
cublasCXX=$(find /usr/local -name "nvcc") CUDACXX=$(find /usr/local -name "nvcc") cmake -DWHISPER_STANDALONE:BOOL=ON -DBUILD_SHARED_LIBS:BOOL=OFF -DWHISPER_OPENBLAS:BOOL=ON -DWHISPER_CUBLAS:BOOL=ON -DWHISPER_STATIC:BOOL=ON ..
make clean
make -j$(nproc)

%install
mkdir -p %{buildroot}%{_bindir}
cp %{_builddir}/target/bin/main %{buildroot}%{_bindir}/whispercpp-cublas

%clean
rm -rf %{buildroot}

%files
%attr(755,root,root) %{_bindir}/whispercpp-cublas

%changelog
* Sat Apr 29 2023 Martin Schamberger <martin.schamberger@univie.ac.at> - 1.4.0-0
- whispercpp-cublas 1.4.0
