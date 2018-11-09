default: src/Main.elm style/main.css
	elm make src/Main.elm --output elm.js
	sass style/sass/main.scss style/main.css

style: style/sass/*
	sass style/sass/main.scss style/main.css
