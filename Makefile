.PHONY: clean
.PHONY: report

clean:
	rm -f plots/*
	rm -f report.pdf
	rm -f report.aux
	rm -f report.html

report: report.html

report.pdf: report.Rmd plots/plot_events.png plots/plot_recent.png \
plots/plot_tornado.png plots/plot_klat.png plots/plot_klon.png \
plots/plot_top50.png plots/plot_weatherterms.png \
plots/plot_kmap.png plots/kable_pc1.rds plots/kable_pc2.rds
	Rscript -e 'rmarkdown::render("report.Rmd", "pdf_document")'

report.html: report.Rmd plots/plot_events.png plots/plot_recent.png \
plots/plot_tornado.png plots/plot_klat.png plots/plot_klon.png \
plots/plot_top50.png plots/plot_weatherterms.png \
plots/plot_kmap.png plots/kable_pc1.rds plots/kable_pc2.rds
	Rscript -e 'rmarkdown::render("report.Rmd", "html_document")'

plots/plot_events.png plots/plot_recent.png plots/plot_tornado.png: \
source_data/1974_2024-08_stormevents.rds scripts/map_events.R
	Rscript scripts/map_events.R

plots/plot_klat.png plots/plot_klon.png plots/plot_kmap.png: \
source_data/1974_2024-08_stormevents.rds scripts/cluster_cost.R
	Rscript scripts/cluster_cost.R

plots/kable_pc1.rds plots/kable_pc2.rds: \
source_data/1974_2024-08_stormevents.rds scripts/pca.R
	Rscript scripts/pca.R

plots/words.rds: source_data/1974_2024-08_stormevents.rds \
scripts/count_words.R
	Rscript scripts/count_words.R

plots/plot_top50.png plots/plot_weatherterms.png: \
plots/words.rds source_data/stopwords.txt scripts/plot_word_counts.R
	Rscript scripts/plot_word_counts.R
