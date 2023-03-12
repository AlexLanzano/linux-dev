ifndef target
%:
	$(MAKE) -f boards/$@/Makefile board=$@ root-dir=$(PWD)
else
%:
	$(MAKE) -f boards/$@/Makefile board=$@ root-dir=$(PWD) $(target)
endif
