/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.Reaction
import java.util.List
import java.util.ArrayList

class ReactionGen implements XMLGenerator {
	
	private static final CharSequence DEFAULT = "SAPEREReaction"
	private static final CharSequence DEFAULT_EXPRESSION = "SAPEREExponentialTime"
	private final List<ConditionGen> conditions = new ArrayList(3)
	private final List<ActionGen> actions = new ArrayList(3)
	private final CharSequence name
	private final CharSequence timedist
	private final CharSequence typeDesc
	private CharSequence xml
	
	public new(Reaction r, int pn, int rn) {
		if(r.name == null) {
			name = '''reaction_p«pn»r«rn»'''
		} else {
			name = r.name;
		}
		if(r.timeDistribution == null) {
			timedist = '''type="«DEFAULT_EXPRESSION»" p0="«IF r.rate==null»Infinity«ELSE»«r.rate»«ENDIF»" p1="RANDOM"'''
		} else {
			timedist = Utils.convertJavaConstructor(r.timeDistribution)
		}
		if (r.type == null) {
			typeDesc = '''type="«DEFAULT»" p0="ENV" p1="NODE" p2="RANDOM" p3="TIMEDIST"'''
		} else {
			typeDesc = Utils.convertJavaConstructor(r.type)
		}
	}
	
	def public addCondition(ConditionGen c) {
		conditions.add(c)
	}
	
	def public addAction(ActionGen a) {
		actions.add(a)
	}
	
	override generateXML(int i) {
		if (xml == null) {
			xml = 
'''«Utils.indent(i)»<timedistribution name="time_«name»" «timedist»></timedistribution>
«Utils.indent(i)»<reaction name="«name»" «typeDesc»>
«FOR c: conditions»«c.generateXML(i+1)»
«ENDFOR»
«FOR a: actions»«a.generateXML(i+1)»
«ENDFOR»
«Utils.indent(i)»</reaction>
'''
		}
		xml
	}
	
}
	
