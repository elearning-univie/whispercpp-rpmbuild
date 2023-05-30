%define debug_package %{nil}
%define __strip /bin/true
%define _prefix /usr

Name:          whispercpp-ggml-%ggmodel
Version:       %{version}
Release:       %{relver}%{?date:.%{?date}%{?date:git}%{?rel}}%{?dist}
Summary:       C++ implemetataion of OpenAI's Whisper ASR model
License:       MIT License
Group:         Applications/Multimedia
URL:           https://github.com/ggerganov/whisper.cpp
Source0:       https://github.com/ggerganov/whisper.cpp/archive/refs/tags/v%{version}.tar.gz
BuildArch:     %arch
Requires:      whispercpp

%description
High-performance inference of OpenAI's Whisper automatic speech
recognition (ASR) model - %ggmodel ggml model.

%prep
rm -rf %{_sourcedir}
mkdir -p %{_sourcedir}
cd %{_sourcedir}
wget https://github.com/ggerganov/whisper.cpp/archive/refs/%{src_path}
tar -xzf *.tar.gz --strip-components 1 -C %{_builddir}

%build
cd %{_builddir}
rm -rf models/*.bin
models/download-ggml-model.sh %ggmodel

%install
rm -rf %{buildroot}
mkdir -m 755 -p %{buildroot}%{_datarootdir}/ggml
cp %{_builddir}/models/ggml-%ggmodel.bin %{buildroot}%{_datarootdir}/ggml/ggml-%ggmodel.bin

%clean
rm -rf %{buildroot}

%files
%attr(644,root,root) %{_datarootdir}/ggml/ggml-%ggmodel.bin

%changelog
* Sat Apr 29 2023 Martin Schamberger <martin.schamberger@univie.ac.at> - 1.4.0-0
- ggml-%ggmodel 1.4.0
