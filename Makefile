.PHONY: clean

clean:
	rm -rf deriv
	rm -rf logs
	rm -rf figs

report.pdf: report.Rmd