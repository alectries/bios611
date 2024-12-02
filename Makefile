.PHONY: clean
.PHONY: report

clean:
	rm -rf plots
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
source_data/1974_2024-08_stormevents.rds scripts/map_events.R plots
	Rscript scripts/map_events.R

plots/plot_klat.png plots/plot_klon.png plots/plot_kmap.png: \
source_data/1974_2024-08_stormevents.rds scripts/cluster_cost.R plots
	Rscript scripts/cluster_cost.R

plots/kable_pc1.rds plots/kable_pc2.rds: \
source_data/1974_2024-08_stormevents.rds scripts/pca.R plots
	Rscript scripts/pca.R

plots/words.rds: source_data/1974_2024-08_stormevents.rds \
scripts/count_words.R plots
	Rscript scripts/count_words.R

plots/plot_top50.png plots/plot_weatherterms.png: \
plots/words.rds source_data/stopwords.txt scripts/plot_word_counts.R \
plots
	Rscript scripts/plot_word_counts.R

plots:
	mkdir plots
