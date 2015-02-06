/*
 * Copyright (C) 2010-2014, Danilo Pianini and contributors
 * listed in the project's pom.xml file.
 * 
 * This file is part of Alchemist, and is distributed under the terms of
 * the GNU General Public License, with a linking exception, as described
 * in the file LICENSE in the Alchemist distribution's top directory.
 */
package it.unibo.alchemist.language.generator

import it.unibo.alchemist.language.saperedsl.JavaConstr

final class Utils {

	private static final double DOUBLE_EQUALITY_EPSILON = 10e-12;
	
	private new() {
	}

	def public static convertJavaConstructor(JavaConstr jc) {
		var i = -1;
		'''type="«jc.javaClass»"«
		IF jc.javaArgList != null»«
			FOR arg : jc.javaArgList.args
				» p«i = i + 1»="«
				IF arg.startsWith("\"") && arg.endsWith("\"")
					»«arg.substring(1,arg.length-1).checkForSpecialCharacter»«
				ELSE
					»«arg.checkForSpecialCharacter»«
				ENDIF
				»"«
			ENDFOR
			»«
		ENDIF»'''
	}
	
	def public static indent(int n) {
		'''«IF n>0»«FOR i: 0..n-1»	«ENDFOR»«ENDIF»'''
	}

	def public static checkForSpecialCharacter(String s) {
		var newString = s
		newString = newString.replaceAll("&", "&amp;")
		newString = newString.replaceAll(">", "&gt;")
		newString = newString.replaceAll("<", "&lt;")
		newString = newString.replaceAll("\"", "&quot;")
		newString = newString.replaceAll("\'", "&#39;")
		return newString
	}
	
	def public static checkDefault(JavaConstr type, CharSequence defVal){
		'''«IF type == null»type="«defVal»"«ELSE»«Utils.convertJavaConstructor(type)»«ENDIF»'''
	}

	def public static checkDefault(CharSequence type, CharSequence defVal){
		'''type="«IF type == null»«defVal»«ELSE»«type»«ENDIF»"'''
	}

	def public static checkDefault(CharSequence defVal){
		'''type="«defVal»"'''
	}
	
	def public static genMolName(boolean condition, int prn, int ren, int acn){
		'''mol_p«prn»r«ren»«IF condition»c«ELSE»a«ENDIF»«acn»'''
	}

	def public static genMolName(int groupn, int contn, int eln){
		'''mol_g«groupn»c«contn»e«eln»'''
	}

	def public static genActName(int prn, int ren, int acn){
		'''act_p«prn»r«ren»c«acn»'''
	}

	def public static genCondName(int prn, int ren, int acn){
		'''cond_p«prn»r«ren»c«acn»'''
	}
	
	def public static fuzzyEquals(double a, double b) {
		return Math.abs(a - b) <= DOUBLE_EQUALITY_EPSILON * Math.max(Math.abs(a), Math.abs(b));
	}
	
	def public static pd(String s) {
		Double.parseDouble(s)
	}

}
