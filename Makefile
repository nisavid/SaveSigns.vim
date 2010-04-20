SCRIPT=plugin/savesignsPlugin.vim autoload/savesigns.vim
DOC=doc/savesigns.txt
PLUGIN=savesigns

.PHONY : $(PLUGIN).vba

all: $(PLUGIN) $(PLUGIN).vba

clean:
	rm -rf *.vba */*.orig *.~* .VimballRecord doc/tags

dist-clean: clean

vimball: $(PLUGIN).vba

install:
	vim -u NONE -N -c':so' -c':q!' ${PLUGIN}.vba

uninstall:
	vim -u NONE -N -c':RmVimball ${PLUGIN}.vba'

undo:
	for i in */*.orig; do mv -f "$$i" "$${i%.*}"; done

savesigns.vba:
	vim -N -c 'ru! vimballPlugin.vim' -c ':let g:vimball_home=getcwd()'  -c ':call append("0", ["plugin/savesignsPlugin.vim", "autoload/savesigns.vim", "doc/savesigns.txt"])' -c '$$d' -c ':%MkVimball ${PLUGIN}' -c':q!'

savesigns:
	rm -f ${PLUGIN}.vba
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d)*/sprintf(".%d", 1+$$1)/e}' ${SCRIPT}
	perl -i -pne 'if (/^let g:loaded_undo_browse/) {s/\.(\d)*/sprintf(".%d", 1+$$1)/e}' ${SCRIPT}
	perl -i -pne 'if (/GetLatestVimScripts:/) {s/(\d+)\s+:AutoInstall:/sprintf("%d :AutoInstall:", 1+$$1)/e}' ${SCRIPT}
	perl -i -pne 'if (/Last Change:/) {s/(:\s+).*$$/sprintf(": %s", `date -R`)/e}' ${SCRIPT}
	perl -i.orig -pne 'if (/Version:/) {s/\.(\d)+.*\n/sprintf(".%d %s", 1+$$1, `date -R`)/e}' ${DOC}