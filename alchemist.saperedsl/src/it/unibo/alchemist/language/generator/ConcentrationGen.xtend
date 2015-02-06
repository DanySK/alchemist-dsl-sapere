/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.Concentration

class ConcentrationGen extends ContentLessGen {

	private final CharSequence descLine;

	new(Concentration obj) {
		super("concentration")
		if (obj == null) {
			descLine = '''type="LsaConcentration"'''
		} else {
			descLine = '''type="«obj.type»'''
		}
	}
	
	override getDescriptionLine() {
		descLine
	}

}
