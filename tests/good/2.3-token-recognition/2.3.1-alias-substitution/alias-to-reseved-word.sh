#!/bin/sh

alias si='if'
alias alors='then'
alias sinon='else'
alias cesttout='fi'
alias blabla='echo'

si [ -n a ]
alors
	blabla oui
sinon
	blabla non
cesttout
