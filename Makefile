include config.mk

PAGES = $(shell find ${PAGES_DIR} -name "*.md")
PAGES_SUBDIRS = $(shell find ${PAGES_DIR} -type d)
ARTICLES = $(shell find ${ARTICLES_DIR} -name "*.md")
ARTICLES_SUBDIRS = $(shell find ${ARTICLES_DIR} -type d)
TEMPLATES = $(shell find ${TEMPLATES_DIR} -type f)

all: deploy

build: $(PAGES:${PAGES_DIR}/%.md=${OUTPUT_DIR}/%.html) $(ARTICLES:${ARTICLES_DIR}/%.md=${OUTPUT_ARTICLES_DIR}/%.html) ${OUTPUT_DIR}/rss.xml ${OUTPUT_DIR}/sitemap.xml

deploy: build
	rsync -rLtvz ${ASSETS_DIR} ${OUTPUT_DIR}/ ${OUTPUT_REMOTE};

clean:
	rm -rf ${OUTPUT_DIR};

${OUTPUT_DIR}/%.html: ${TEMPLATES} ${PAGES_DIR}/%.md
	mkdir -p ${PAGES_SUBDIRS:${PAGES_DIR}%=${OUTPUT_DIR}%}; \
	cp -r ${ASSETS_DIR} ${OUTPUT_DIR}; \
	TITLE="$(shell sed -e 1!d $(@:${OUTPUT_DIR}/%.html=${PAGES_DIR}/%.md))"; \
	export TITLE; \
	DESC="$(shell sed -e 2!d $(@:${OUTPUT_DIR}/%.html=${PAGES_DIR}/%.md))"; \
	export DESC; \
	TAGS="$(shell sed -e 3!d $(@:${OUTPUT_DIR}/%.html=${PAGES_DIR}/%.md))"; \
	export TAGS; \
	envsubst < ${TEMPLATES_DIR}/header.html > $@; \
	envsubst < ${TEMPLATES_DIR}/page_header.html >> $@; \
	sed -e 1,4d $(@:${OUTPUT_DIR}/%.html=${PAGES_DIR}/%.md) | markdown >> $@; \
	envsubst < ${TEMPLATES_DIR}/page_footer.html >> $@; \
	envsubst < ${TEMPLATES_DIR}/footer.html >> $@;

${OUTPUT_ARTICLES_DIR}/%.html: ${TEMPLATES} ${ARTICLES_DIR}/%.md
	mkdir -p ${ARTICLES_SUBDIRS:${ARTICLES_DIR}%=${OUTPUT_ARTICLES_DIR}%}; \
	cp -r ${ASSETS_DIR} ${OUTPUT_DIR}; \
	TITLE="$(shell sed -e 1!d $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md))"; \
	export TITLE; \
	DESC="$(shell sed -e 2!d $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md))"; \
	export DESC; \
	TAGS="$(shell sed -e 3!d $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md))"; \
	export TAGS; \
	PUB_DATE="$(shell git log --diff-filter=A --date="format:%x %X" --pretty=format:'%ad' -- $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md))"; \
	export PUB_DATE; \
	EDIT_DATE="$(shell git log -n 1 --date="format:%x %X" --pretty=format:'%ad' -- $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md))"; \
	export EDIT_DATE; \
	envsubst < ${TEMPLATES_DIR}/header.html > $@; \
	envsubst < ${TEMPLATES_DIR}/article_header.html >> $@; \
	sed -e 1,4d $(@:${OUTPUT_ARTICLES_DIR}/%.html=${ARTICLES_DIR}/%.md) | markdown >> $@; \
	envsubst < ${TEMPLATES_DIR}/article_footer.html >> $@; \
	envsubst < ${TEMPLATES_DIR}/footer.html >> $@;

${OUTPUT_DIR}/rss.xml: ${ARTICLES}
	printf '<?xml version="1.0" encoding="UTF-8"?>\n<rss version="2.0">\n<channel>\n<title>%s</title>\n<link>%s</link>\n<description>%s</description>\n' \
		"${TITLE}" "${URL}" "${DESC}" > $@;
	for f in ${ARTICLES}; do \
		printf '%s ' "$$f"; \
		git log --diff-filter=A --date="format:%s %a, %d %b %Y %H:%M:%S %z" --pretty=format:'%ad%n' -- "$$f"; \
	done | sort -k2nr | cut -d" " -f1,3- | while IFS=" " read -r FILE DATE; do \
		printf '<item>\n<title>%s</title>\n<link>%s</link>\n<guid>%s</guid>\n<pubDate>%s</pubDate>\n<description><![CDATA[%s]]></description>\n</item>\n' \
			"`sed -e 1!d $$FILE`" \
			"${URL}/`echo $$FILE | sed -e 's/.md//g'`" \
			"${URL}/`echo $$FILE | sed -e 's/.md//g'`" \
			"$$DATE" \
			"`sed -e 1,4d $$FILE | markdown`"; \
	done >> $@
	printf '</channel>\n</rss>\n' >> $@

${OUTPUT_DIR}/sitemap.xml: ${PAGES} ${ARTICLES}
	printf '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' > $@; \
	for f in ${PAGES} ${ARTICLES}; do \
		printf '%s ' "$$f"; \
		git log -n 1 --date="format:%Y-%m-%d" --pretty=format:'%ad%n' -- "$$f"; \
	done | sort -k2nr | while IFS=" " read -r FILE DATE; do \
		printf '<url>\n<loc>%s</loc>\n<lastmod>%s</lastmod>\n</url>\n' \
			"${URL}/`echo $$FILE | sed -e 's/.md//g' -e 's/${PAGES_DIR}\///g'`" \
			"$$DATE"; \
	done >> $@
	printf '</urlset>\n' >> $@

.PHONY: all build deploy clean
