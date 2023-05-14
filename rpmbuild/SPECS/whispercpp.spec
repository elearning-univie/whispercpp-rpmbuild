%define version 1.4.0
%define debug_package %{nil}
%define __strip /bin/true

Name:          whispercpp
Version:       %{version}
Release:       2%{?date:.%{?date}%{?date:git}%{?rel}}%{?dist}
Summary:       C++ implemetataion of OpenAI's Whisper ASR model
License:       MIT License
Group:         Applications/Multimedia
URL:           https://github.com/ggerganov/whisper.cpp
#Source:       https://ffmpeg.org/releases/ffmpeg-%{version}.tar.bz2

%description
High-performance inference of OpenAI's Whisper automatic speech
recognition (ASR) model.

%prep

mkdir -p %{_builddir}/bin

cp -RT ../whispercpp %{_builddir}/bin/whispercpp

%build


%install
rm -rf %{buildroot}
mkdir -m 755 -p %{buildroot}%{_bindir}
mkdir -m 755 -p %{buildroot}%{_datarootdir}/man/man1

cp %{_builddir}/bin/whispercpp \
    %{buildroot}%{_bindir}/whispercpp

%clean
rm -rf ${buildroot}

%files
%attr(755,root,root) %{_bindir}/whispercpp

%changelog
* Sat Apr 29 2023 Martin Schamberger <martin.schamberger@univie.ac.at> - 1.4.0-0
- whispercpp 1.4.0
