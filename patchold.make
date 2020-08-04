--- tools/Makefile	2019-11-20 00:01:25.831291179 -0600
+++ tools/Makefile	2019-11-20 00:01:47.667137347 -0600
@@ -5,9 +5,9 @@
 # NOTE(kan-bayashi): Use 3.7.3 to avoid sentencepiece installation error
 PYTHON_VERSION := 3.7.3
-CUPY_VERSION := 6.0.0
-CUDA_VERSION := 10.0
+CUPY_VERSION := 6.7.0
+CUDA_VERSION := 10.2
 # PyTorch version: 0.4.1 or 1.0.0 or 1.0.1
-TH_VERSION := 1.0.1
+TH_VERSION := 1.3.0a0+ee77ccb
 # Use a prebuild Kaldi to omit the installation
 KALDI :=
 WGET := wget --tries=3
@@ -54,7 +54,7 @@
 espnet.done: venv
 	. venv/bin/activate; pip install pip --upgrade
 	. venv/bin/activate; pip install -e ..
-	. venv/bin/activate; pip install torch==$(TH_VERSION)
+	. venv/bin/activate; pip install torch-1.3.0a0+ee77ccb-cp37-cp37m-linux_x86_64.whl
 	touch espnet.done
 else
 miniconda.sh:
@@ -74,17 +74,17 @@
 
 cupy.done: espnet.done
 ifneq ($(strip $(CUPY_VERSION)),)
-	. venv/bin/activate && pip install cupy-cuda$(strip $(subst .,,$(CUDA_VERSION)))==$(CUPY_VERSION)
+	. venv/bin/activate && pip install cupy==$(CUPY_VERSION)
 	touch cupy.done
 endif
 
 warp-ctc.done: espnet.done
 	if . venv/bin/activate && python -c 'import torch as t;major=t.__version__.split(".")[0];assert major == "1"' &> /dev/null; then \
-		if [ ! -z "$(strip $(CUPY_VERSION))" ]; then \
-			. venv/bin/activate && pip install warpctc-pytorch10-cuda$(strip $(subst .,,$(CUDA_VERSION))); \
-		else \
-			. venv/bin/activate && pip install warpctc-pytorch10-cpu; \
-		fi \
+		rm -rf warp-ctc; \
+		git clone https://github.com/espnet/warp-ctc.git; \
+		cd warp-ctc; git checkout -b pytorch-1.1 remotes/origin/pytorch-1.1; \
+		mkdir build && cd build && cmake .. && $(MAKE) && cd ..; \
+		. ../venv/bin/activate; pip install cffi; cd pytorch_binding && python setup.py install; \
 	else \
 		rm -rf warp-ctc; \
 		git clone https://github.com/espnet/warp-ctc.git; \
