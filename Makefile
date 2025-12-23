switch:
	home-manager switch -b backup --flake .

update:
	nix flake update
	make switch
