.PHONY: docker-decred
docker-decred:
	docker build -t kern/staked-decred decred

.PHONY: packer-decred
packer-decred:
	packer validate decred/decred.json
	packer build decred/decred.json
