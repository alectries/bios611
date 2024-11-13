# Set default graphics device to Cairo
if (interactive() && require("grDevices", quietly = TRUE)) {
    # Check if we're in RStudio
    if (Sys.getenv("RSTUDIO") == "1") {
        # First try to load Cairo package
        if (require("Cairo", quietly = TRUE)) {
            options(device = Cairo::CairoPDF)
            options(bitmapType = "cairo")
        } else {
            # Fallback to built-in cairo capabilities
            options(device = cairo_pdf)
            if (capabilities("cairo")) {
                options(bitmapType = "cairo")
            }
        }
    }
}

# Ensure PNG device uses Cairo
options(device.ask.default = FALSE)
grDevices::X11.options(type = "cairo")

# Set default graphics parameters
options(repr.plot.width = 7)
options(repr.plot.height = 7)
