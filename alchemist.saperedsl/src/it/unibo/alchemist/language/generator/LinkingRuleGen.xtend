/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.LinkingRule

class LinkingRuleGen extends ContentLessGen {

	private final CharSequence descLine;

	new(LinkingRule lr) {
		super("linkingrule")
		if (lr.type == null) {
			descLine = '''type="EuclideanDistance" p0="«lr.range»"'''
		} else {
			descLine = Utils.convertJavaConstructor(lr.type)
		}
	}
	
	override getDescriptionLine() {
		descLine
	}

}
