--- tools/Makefile	2020-08-04 22:18:52.482310000 -0500
+++ tools/Makefile	2020-08-04 22:28:51.979893703 -0500
@@ -4,7 +4,7 @@
 # Disable cupy installation
 NO_CUPY :=
 # PyTorch version: 0.4.1, 1.0.0, 1.0.1, 1.1.0, 1.2.0, 1.3.0, 1.3.1, 1.4.0, 1.5.0, 1.5.1, 1.6.0
-TH_VERSION := 1.4.0
+TH_VERSION := 1.6.0
 WGET := wget --tries=3
 
 # Use pip for pytorch installation even if you have anaconda
@@ -18,16 +18,11 @@
 
 
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
@@ -55,9 +50,9 @@
 all: kaldi showenv python conda_packages.done check_install
 
 ifneq ($(strip $(CHAINER_VERSION)),)
-python: activate_python.sh warp-ctc.done warp-transducer.done espnet.done pytorch.done chainer_ctc.done chainer.done
+python: espnet.done chainer.done
 else
-python: activate_python.sh warp-ctc.done warp-transducer.done espnet.done pytorch.done
+python: espnet.done
 endif
 
 extra: nkf.done moses.done mwerSegmenter.done pesq kenlm.done
@@ -71,7 +66,6 @@
 ################ Logging ################
 showenv: activate_python.sh
 ifeq ($(strip $(CPU_ONLY)),)
-	[ -n "${CUDA_HOME}" ] || { echo -e "Error: CUDA_HOME is not set.\n    $$ . ./setup_cuda_env.sh <cuda-root>"; exit 1; }
 	@echo CUDA_VERSION=$(CUDA_VERSION)
 else
 	@echo Perform on CPU mode: CPU_ONLY=$(CPU_ONLY)
