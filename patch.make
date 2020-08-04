--- tools/Makefile	2020-07-28 13:13:07.636760000 -0500
+++ tools/Makefile	2020-07-28 13:53:31.814594930 -0500
@@ -7,13 +7,13 @@
 CONDA_ENV_NAME := espnet
 # The python version installed in the conda setup
 # NOTE(kan-bayashi): Use 3.7.3 to avoid sentencepiece installation error
-PYTHON_VERSION := 3.7.3
+PYTHON_VERSION := 3.8
 # If empty string is given, chainer is not installed. Note that ESPnet doesn't support any versions except for chainer=6.0.0
 CHAINER_VERSION := 6.0.0
 # Disable cupy installation
 NO_CUPY :=
 # PyTorch version: 0.4.1, 1.0.0, 1.0.1, 1.1.0, 1.2.0, 1.3.0, 1.3.1, 1.4.0, 1.5.0, 1.5.1, 1.6.0
-TH_VERSION := 1.4.0
+TH_VERSION := 1.6.0
 # Use a prebuild Kaldi to omit the installation
 KALDI :=
 WGET := wget --tries=3
@@ -26,16 +26,11 @@
 endif
 
 # Set if install binaries on CPU mode e.g. make CPU_ONLY=1
-# If you don't have any GPUs, this value will be set automatically
-ifeq ($(shell which nvcc),) # 'nvcc' not found
-CPU_ONLY := 0
-else
 CPU_ONLY :=
-endif
 
 ifeq ($(strip $(CPU_ONLY)),)
 # Derive CUDA version from nvcc
-CUDA_VERSION = $(shell nvcc --version | grep "Cuda compilation tools" | cut -d" " -f5 | sed s/,//)
+CUDA_VERSION = 10.2
 CUDA_VERSION_WITHOUT_DOT = $(strip $(subst .,,$(CUDA_VERSION)))
 CONDA_PYTORCH := pytorch=$(TH_VERSION) cudatoolkit=$(CUDA_VERSION)
 PIP_PYTORCH := torch==$(TH_VERSION) -f https://download.pytorch.org/whl/cu$(CUDA_VERSION_WITHOUT_DOT)/torch_stable.html
@@ -63,9 +58,9 @@
 all: showenv kaldi.done python check_install
 
 ifneq ($(strip $(CHAINER_VERSION)),)
-python: activate_python.sh warp-ctc.done warp-transducer.done espnet.done pytorch.done chainer_ctc.done chainer.done
+python: espnet.done chainer.done
 else
-python: activate_python.sh warp-ctc.done warp-transducer.done espnet.done pytorch.done
+python: espnet.done
 endif
 
 extra: nkf.done moses.done mwerSegmenter.done pesq kenlm.done
@@ -209,13 +204,13 @@
 clean: clean_extra
 	rm -rf kaldi venv warp-ctc warp-transducer chainer_ctc
 	rm -f miniconda.sh
-	rm -rf *.done
+	rm -rf *.done activate_python.sh
 	find . -iname "*.pyc" -delete
 
 clean_python:
 	rm -rf venv warp-ctc warp-transducer chainer_ctc
 	rm -f miniconda.sh
-	rm -f warp-ctc.done chainer_ctc.done espnet.done chainer.done pytorch.done warp-transducer.done
+	rm -f warp-ctc.done chainer_ctc.done espnet.done chainer.done pytorch.done warp-transducer.done activate_python.sh
 	find . -iname "*.pyc" -delete
 
 clean_extra:
