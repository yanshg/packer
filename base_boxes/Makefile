all: build

json: clean
	cd packer; \
	./generate_json.sh

virtualbox: 
	@cd packer; \
        for json in *.json; do \
            echo packer build -only=virtualbox-iso -var mirror="<iso_dir>" $$json; \
        done

virtualbox_debug:
	@cd packer; \
        for json in *.json; do \
            echo PACKER_LOG=1 packer build -only=virtualbox-iso -var mirror="<iso_dir>" $$json; \
        done

vmware: 
	@cd packer; \
        for json in *.json; do \
            echo packer build -only=vmware-iso -var mirror="<iso_dir>" $$json; \
        done

build: json virtualbox vmware

clean:
	cd packer; \
	rm -rf *.json

