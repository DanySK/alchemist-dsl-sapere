/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import java.util.List
import java.util.ArrayList
import java.util.Map
import java.util.HashMap
import java.util.Iterator
import java.util.Random
import it.unibo.alchemist.language.saperedsl.Environment

class EnvironmentGen implements XMLGenerator {

	private final String name;
	private final CharSequence typeAndParams;
	private final LinkingRuleGen lr;
	private final ConcentrationGen conc;
	private final PositionGen pos;
	private final RandomEngineGen rand;
	private final CharSequence timetype;
	private final List<MoleculeGen> molecules = new ArrayList;
	private final Map<CharSequence, List<ReactionGen>> pools = new HashMap
	private final List<NodeGen> nodes = new ArrayList;

	new(Environment env) {
		if (env.name == null) {
			name = "environment"
		} else {
			name = '''«env.name»'''
		}
		typeAndParams = Utils.checkDefault(env.type, "Continuous2DEnvironment")
		val rngSeed = env.internalRNGSeed;
		lr = new LinkingRuleGen(env.linkingRule)
		conc = new ConcentrationGen(env.concentration)
		pos = new PositionGen(env.position)
		if (env.time != null) {
			timetype = Utils.checkDefault(env.time.type, "DoubleTime")
		} else {
			timetype = "DoubleTime"
		}
		rand = new RandomEngineGen(env.random)
		env.molecules.forEach[molecules.add(new MoleculeGen(it))]
		env.programs.forEach [ pr, prn |
			val list = new ArrayList
			pools.put(pr.name, list)
			pr.reactions.forEach [ re, ren |
				val reaction = new ReactionGen(re, prn, ren)
				list.add(reaction)
				re.conditions.forEach [ cnd, cndn |
					reaction.addCondition(new ConditionGen(cnd, prn, ren, cndn))
					if (cnd.type == null) {
						if (cnd.content.mol == null) {
							molecules.add(new MoleculeGen(Utils.genMolName(true, prn, ren, cndn), cnd.content.text))
						}
					}
				]
				re.actions.forEach [ act, actn |
					reaction.addAction(new ActionGen(act, prn, ren, actn))
					if (act.type == null) {
						if (act.content.mol == null) {
							molecules.add(new MoleculeGen(Utils.genMolName(false, prn, ren, actn), act.content.text))
						}
					}
				]
			]
		]
		env.elements.forEach [ group, gn |
			group.contents.forEach [ cstr, cnti |
				cstr.contents.forEach [ elem, eln |
					if (elem.mol == null) {
						molecules.add(new MoleculeGen(Utils.genMolName(gn, cnti, eln), elem.text))
					}
				]
			]
			var Iterator<double[]> posGen;
			if (group.gtype.equals("single")) {
				posGen = new SinglePositionGen(Utils.pd(group.x), Utils.pd(group.y))
			} else if (group.gtype.equals("rect")) {
				posGen = new RectPositionGen(group.numNodes, Utils.pd(group.x), Utils.pd(group.y), Utils.pd(group.w),
					Utils.pd(group.h), group.ix, group.iy, group.tx, group.ty, new Random(rngSeed))
			} else {
				posGen = new CirclePositionGen(group.numNodes, Utils.pd(group.x), Utils.pd(group.y), Utils.pd(group.r), new Random(rngSeed))
			}
			posGen.forEach [ posArray, i |
				val node = new NodeGen(gn, i, group, posArray)
				nodes.add(node)
				group.contents.forEach [ cstr, cnti |
					var cond = true;
					if (cstr.ctype.equals("rect")) {
						val x = Utils.pd(cstr.x)
						val y = Utils.pd(cstr.y)
						val w = Utils.pd(cstr.w)
						val h = Utils.pd(cstr.h)
						val px = posArray.get(0)
						val py = posArray.get(1)
						cond = withinBorders(px, x, w) && withinBorders(py, y, h)
					} else if (cstr.ctype.equals("point")) {
						val x = Utils.pd(cstr.x)
						val y = Utils.pd(cstr.y)
						cond = e(x, posArray.get(0)) && e(y, posArray.get(1))
					}
					if (cond) {
						cstr.contents.forEach [ elem, eln |
							if (elem.mol == null) {
								node.addContent(Utils.genMolName(gn, cnti, eln))
							} else {
								node.addContent(elem.mol.name)
							}
						]
					}
				]
				group.reactions.forEach [
					node.addProgram(pools.get(it.name))
				]
			]
		]
	}
	
	def static private withinBorders(double p, double i, double s){
		(p >= i && p <= i+s) || e(p,i) || e(p, i+s)
	}
	
	def static private e(double a, double b) {
		Utils.fuzzyEquals(a, b)
	}

	override generateXML(int indent) {
'''<?xml version="1.0" encoding="UTF-8"?>
<environment name="«name»" «typeAndParams»>
«lr.generateXML(1)»
«conc.generateXML(1)»
«pos.generateXML(1)»
«rand.generateXML(1)»
«FOR mol : molecules»«mol.generateXML(1)»
«ENDFOR»
«FOR n : nodes»«n.generateXML(1)»
«ENDFOR»
</environment>'''
	}

}
