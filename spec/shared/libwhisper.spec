%define version 1.4.0
%define debug_package %{nil}
%define __strip /bin/true
%define _prefix /usr

Name:          libwhisper
Version:       %{version}
Release:       %{relver}%{?date:.%{?date}%{?date:git}%{?rel}}%{?dist}
Summary:       C++ implemetataion of OpenAI's Whisper ASR model
License:       MIT License
Group:         Applications/Multimedia
URL:           https://github.com/ggerganov/whisper.cpp
Source0:       https://github.com/ggerganov/whisper.cpp/archive/refs/heads/master.zip
BuildArch:     x86_64
BuildRequires: make cmake wget gcc gcc-c++

%description
High-performance inference of OpenAI's Whisper automatic speech
recognition (ASR) model. WhisperC++ library.

%install
mkdir -p %{buildroot}%{_includedir}
mkdir -p %{buildroot}%{_libdir}
cp %{_builddir}/whisper.h %{buildroot}%{_includedir}/whisper.h
cp %{_builddir}/target/libwhisper.so %{buildroot}%{_libdir}/libwhisper.so

%clean
rm -rf ${buildroot}

%files
%attr(644,root,root) %{_includedir}/whisper.h
%attr(644,root,root) %{_libdir}/libwhisper.so

%changelog
* Sat Apr 29 2023 Martin Schamberger <martin.schamberger@univie.ac.at> - 1.4.0-0
- libwhisper 1.4.0
