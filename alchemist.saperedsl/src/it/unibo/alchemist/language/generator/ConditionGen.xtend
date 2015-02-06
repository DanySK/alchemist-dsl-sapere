/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.Condition

class ConditionGen extends ContentLessGen {
	
	private static final CharSequence DEFAULT = "LsaStandardCondition"
	private static final CharSequence DEFAULT_NEGH = "LsaNeighborhoodCondition"
	private final CharSequence name
	private final CharSequence typeDesc
	
	public new(Condition cond, int pn, int rn, int cn) {
		super("condition")
		if(cond.name != null) {
			name = cond.name;
		} else {
			name = Utils.genCondName(pn,rn,cn)
		}
		if(cond.type == null) {
			if(cond.neigh == null) {
				typeDesc = 	'''type="«DEFAULT»" p0="«IF cond.content.mol == null»«Utils.genMolName(true, pn, rn, cn)»«ELSE»«cond.content.mol.name»«ENDIF»" p1="NODE"'''
			} else {
				typeDesc = 	'''type="«DEFAULT_NEGH»" p0="NODE" p1="«IF cond.content.mol == null»«Utils.genMolName(true, pn, rn, cn)»«ELSE»«cond.content.mol.name»«ENDIF»" p2="ENV"'''
			}
		} else {
			typeDesc = Utils.convertJavaConstructor(cond.type)
		}
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}