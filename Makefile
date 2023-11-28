.PHONY: coverage test formatcheck stylecheck

lint: formatcheck stylecheck typecheck
test:
	python -munittest discover tests
coverage:
	coverage run -m unittest discover tests -v
	coverage report -m --fail-under 100
formatcheck:
	black --check --diff src/* tests/*
stylecheck:
	flake8
typecheck:
	mypy -p liboc.math
build-dist:
	pip install --upgrade --upgrade-strategy eager build
	python -m build
upload-dist: coverage build-dist
	@echo Uploading the following
	@ls -1 dist/*
	@echo "Does this look right, including a version bump? [y/N] " && read ans && [ $${ans:-N} = y ]
	pip install --upgrade --upgrade-strategy eager twine
	python -mtwine upload dist/*
