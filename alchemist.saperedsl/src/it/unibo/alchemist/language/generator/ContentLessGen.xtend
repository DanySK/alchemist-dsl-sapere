/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

abstract class ContentLessGen extends GenericGen {
	
	new(String tagname) {
		super(tagname)
	}
	
	final override getContent(int i) {
		""
	}
	
	final override hasContent() {
		false
	}
	
	
}