# swagger2markup output fed to asciidoctor-pdf - all via published docker images

# The following is a Makefile command in the root of a web service repo with the following assumptions:
# ./swagger/v1/swagger.json is the swagger definition (created by rswag in my case)
# ./_docs/ is where we want the PDF and intermediate ADOC to live
# The ADOC file is pretty useful, but if you just want the PDF, it's a byproduct you might want to clean up

api_pdf:
  docker run --rm -v $(shell pwd):/opt swagger2markup/swagger2markup convert -i /opt/swagger/v1/swagger.json -f /opt/_docs/api-definition
  docker run --rm -v $(shell pwd)/_docs:/documents/ asciidoctor/docker-asciidoctor asciidoctor-pdf api-definition.adoc

# To add configuration options for swagger2markup, create a config.properties file and specify with
# -c /opt/config.properties
# asciidoctor-pdf supports pretty extensive styling:
# https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc#applying-your-theme