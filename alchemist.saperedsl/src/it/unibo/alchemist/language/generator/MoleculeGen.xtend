/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.Molecule

class MoleculeGen extends ContentLessGen {
	
	private final CharSequence name
	private final CharSequence typeDesc
	
	new(Molecule obj) {
		super("molecule")
		name = obj.name;
		if(obj.type == null) {
			typeDesc = '''type="LsaMolecule" p0="«c(obj.content)»"«IF obj.desc != null» p1="«c(obj.desc)»"«ENDIF»'''
		} else {
			typeDesc = Utils.convertJavaConstructor(obj.type)
		}
	}
	
	def private static c(String s) {
		Utils.checkForSpecialCharacter(s)
	}
	
	new(CharSequence n, CharSequence content) {
		super("molecule")
		name = n;
		typeDesc = '''type="LsaMolecule" p0="«c(content.toString)»"'''
	}
	
	override getDescriptionLine() {
		'''name="«name»" «typeDesc»'''
	}
	
}