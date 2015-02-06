/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.Action

class ActionGen extends ContentLessGen {
	
	private static final CharSequence DEFAULT = "LsaStandardAction"
	private static final CharSequence DEFAULT_NEIGH = "LsaRandomNeighborAction"
	private static final CharSequence DEFAULT_ALL = "LsaAllNeighborsAction"
	private final CharSequence name
	private final CharSequence typeDesc
	
	public new(Action act, int pn, int rn, int an) {
		super("action")
		if(act.name != null) {
			name = act.name;
		} else {
			name = Utils.genActName(pn,rn,an)
		}
		if(act.type == null) {
			if(act.neigh == null) {
				typeDesc = '''type="«DEFAULT»" p0="«getMolName(act, pn, rn, an)»" p1="NODE" p2="RANDOM"'''
			} else if(act.neigh.equals("+")) {
				typeDesc = '''type="«DEFAULT_NEIGH»" p0="NODE" p1="«getMolName(act, pn, rn, an)»" p2="ENV" p3="RANDOM"'''
			} else {
				typeDesc = '''type="«DEFAULT_ALL»" p0="NODE" p1="«getMolName(act, pn, rn, an)»" p2="ENV"'''
			}
		} else {
			typeDesc = Utils.convertJavaConstructor(act.type)
		}
	}
	
	def private getMolName(Action act, int pn, int rn, int an) {
		'''«IF act.content.mol == null»«Utils.genMolName(false, pn, rn, an)»«ELSE»«act.content.mol.name»«ENDIF»'''
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}