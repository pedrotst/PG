;; x-symbol-isabelle.el   
;;	Token language "Isabelle Symbols" for package x-symbol
;;
;;  ID:         $Id$
;;  Author:     David von Oheimb
;;              Updates by Markus Wenzel, Christoph Wedler, David Aspinall.
;;  Copyright   1998 Technische Universitaet Muenchen
;;  License     GPL (GNU GENERAL PUBLIC LICENSE)
;;
;;
;; NB: Part of Proof General distribution.
;;
;; This file accounts for differences between Isabelle and 
;; Isabelle/Isar support of X-Symbol tokens, namely:
;;
;; Isabelle:       \\<foo>   (inside ML strings)
;; Isabelle/Isar:  \<foo>
;;

(defvar x-symbol-isabelle-required-fonts nil)

;;;===========================================================================
;;;  General language accesses, see `x-symbol-language-access-alist'
;;;===========================================================================

;; NB da: these next two are also set in proof-x-symbol.el, but
;; it would be handy to be able to use this file away from PG.  
;; FIXME: In future could fix things so just 
;; (require 'proof-x-symbol) would be enough here.
(defvar x-symbol-isabelle-name "Isabelle Symbol")
(defvar x-symbol-isabelle-modeline-name "isa")

(defcustom x-symbol-isabelle-header-groups-alist nil
   "*If non-nil, used in isasym specific grid/menu.
See `x-symbol-header-groups-alist'."
  :group 'x-symbol-isabelle
  :group 'x-symbol-input-init
  :type 'x-symbol-headers)

(defcustom x-symbol-isabelle-electric-ignore 
  "[:'][A-Za-z]\\|<=\\|\\[\\[\\|\\]\\]\\|~="
  "*Additional Isabelle version of `x-symbol-electric-ignore'."
  :group 'x-symbol-isabelle
  :group 'x-symbol-input-control
  :type 'x-symbol-function-or-regexp)


(defvar x-symbol-isabelle-required-fonts nil
  "List of features providing fonts for language `isabelle'.")

(defvar x-symbol-isabelle-extra-menu-items nil
  "Extra menu entries for language `isabelle'.")


(defvar x-symbol-isabelle-token-grammar
  '(x-symbol-make-grammar
    :encode-spec (((t . "\\\\")))
    :decode-regexp "\\\\+<[A-Za-z]+>"
    :input-spec nil
    :token-list x-symbol-isabelle-token-list))

(defun x-symbol-isabelle-token-list (tokens)
  (mapcar (lambda (x) (cons x t)) tokens))

(defvar x-symbol-isabelle-user-table nil
  "User table defining Isabelle commands, used in `x-symbol-isabelle-table'.")

(defvar x-symbol-isabelle-generated-data nil
  "Internal.")


;;;===========================================================================
;;;  No image support
;;;===========================================================================

(defvar x-symbol-isabelle-master-directory  'ignore)
(defvar x-symbol-isabelle-image-searchpath '("./"))
(defvar x-symbol-isabelle-image-cached-dirs '("images/" "pictures/"))
(defvar x-symbol-isabelle-image-file-truename-alist nil)
(defvar x-symbol-isabelle-image-keywords nil)


;;;===========================================================================
;;  super- and subscripts
;;;===========================================================================

;; \<^sup>, \<^sub>, \<^isub>, and \<^isup>.

(defvar x-symbol-isabelle-subscript-matcher
  'x-symbol-isabelle-subscript-matcher)

(defun x-symbol-isabelle-subscript-matcher (limit)  
  (when (re-search-forward x-symbol-isabelle-font-lock-scripts-regexp
			   limit 'limit)
    (if (eq (char-after (- (match-end 1) 2)) ?b)
        'x-symbol-sub-face
      'x-symbol-sup-face)))

(defun x-symbol-isabelle-make-ctrl-regexp (s)
  "Return regexp matching \<^S>\<ident> or \<^S>c for some char c."
  (concat 
   "\\(\\\\\\\\?<\\^" s ">\\)"
   "\\(\\\\\\\\?<[A-Za-z][A-Za-z0-9_']*>\\|[^\\]\\)"))

(defconst x-symbol-isabelle-font-lock-scripts-regexp
  (x-symbol-isabelle-make-ctrl-regexp "i?su[bp]")
  "Regexp matching super- and subscript markers in Isabelle.")

(defun isabelle-match-subscript (limit)
  (if (proof-ass x-symbol-enable)
      (setq x-symbol-isabelle-subscript-type
            (funcall x-symbol-isabelle-subscript-matcher limit))))

;; these are used for Isabelle output only. x-symbol does its own
;; setup of font-lock-keywords for the theory buffer
;; (x-symbol-isabelle-font-lock-keywords does not belong to language
;; access any more)
(defvar x-symbol-isabelle-font-lock-keywords
  '((isabelle-match-subscript
     (1 x-symbol-invisible-face t)
     (2 (progn x-symbol-isabelle-subscript-type) prepend)
     (3 x-symbol-invisible-face t t)))
; lsf: 3 not necessary at the moment but may be useful later
  "Isabelle font-lock keywords for super- and subscripts.")

(defvar x-symbol-isabelle-font-lock-allowed-faces t)


;;;===========================================================================
;;;  Charsym Info
;;;===========================================================================

(defcustom x-symbol-isabelle-class-alist
  '((VALID "Isabelle Symbol" (x-symbol-info-face))
    (INVALID "no Isabelle Symbol" (red x-symbol-info-face)))
  "Alist for Isabelle's token classes displayed by info in echo area.
See `x-symbol-language-access-alist' for details."
  :group 'x-symbol-texi
  :group 'x-symbol-info-strings
;;  :set 'x-symbol-set-cache-variable   [causes compile error]
  :type 'x-symbol-class-info)


(defcustom x-symbol-isabelle-class-face-alist nil
  "Alist for Isabelle's color scheme in TeXinfo's grid and info.
See `x-symbol-language-access-alist' for details."
  :group 'x-symbol-isabelle
  :group 'x-symbol-input-init
  :group 'x-symbol-info-general
;;  :set 'x-symbol-set-cache-variable   [causes compile error]
  :type 'x-symbol-class-faces)



;;;===========================================================================
;;;  The tables
;;;===========================================================================

(defvar x-symbol-isabelle-case-insensitive nil)
(defvar x-symbol-isabelle-token-shape nil)
(defvar x-symbol-isabelle-input-token-ignore nil)
(defvar x-symbol-isabelle-token-list 'identity)

(defvar x-symbol-isabelle-symbol-table      ; symbols (isabelle font)
  '((visiblespace "\\<spacespace>")
    (Gamma "\\<Gamma>")
    (Delta "\\<Delta>")
    (Theta "\\<Theta>")
    (Lambda "\\<Lambda>")
    (Pi "\\<Pi>")
    (Sigma "\\<Sigma>")
    (Phi "\\<Phi>")
    (Psi "\\<Psi>")
    (Omega "\\<Omega>")
    (alpha "\\<alpha>")
    (beta "\\<beta>")
    (gamma "\\<gamma>")
    (delta "\\<delta>")
    (epsilon1 "\\<epsilon>")
    (zeta "\\<zeta>")
    (eta "\\<eta>")
    (theta "\\<theta>")
    (kappa1 "\\<kappa>")
    (lambda "\\<lambda>")
    (mu "\\<mu>")
    (nu "\\<nu>")
    (xi "\\<xi>")
    (pi "\\<pi>")
    (rho1 "\\<rho>")
    (sigma "\\<sigma>")
    (tau "\\<tau>")
    (phi1 "\\<phi>")
    (chi "\\<chi>")
    (psi "\\<psi>")
    (omega "\\<omega>")
    (notsign "\\<not>")
    (logicaland "\\<and>")
    (logicalor "\\<or>")
    (universal1 "\\<forall>")
    (existential1 "\\<exists>")
    (biglogicaland "\\<And>")
    (ceilingleft "\\<lceil>")
    (ceilingright "\\<rceil>")
    (floorleft "\\<lfloor>")
    (floorright "\\<rfloor>")
    (bardash "\\<turnstile>")
    (bardashdbl "\\<Turnstile>")
    (semanticsleft "\\<lbrakk>")
    (semanticsright "\\<rbrakk>")
    (periodcentered "\\<cdot>")
    (element "\\<in>")
    (reflexsubset "\\<subseteq>")
    (intersection "\\<inter>")
    (union "\\<union>")
    (bigintersection "\\<Inter>")
    (bigunion "\\<Union>")
    (sqintersection "\\<sqinter>")
    (squnion "\\<squnion>")
    (bigsqintersection "\\<Sqinter>")
    (bigsqunion "\\<Squnion>")
    (perpendicular "\\<bottom>")
    (dotequal "\\<doteq>")
    (wrong "\\<wrong>")
    (equivalence "\\<equiv>")
    (notequal "\\<noteq>")
    (propersqsubset "\\<sqsubset>")
    (reflexsqsubset "\\<sqsubseteq>")
    (properprec "\\<prec>")
    (reflexprec "\\<preceq>")
    (propersucc "\\<succ>")
    (approxequal "\\<approx>")
    (similar "\\<sim>")
    (simequal "\\<simeq>")
    (lessequal "\\<le>")
    (coloncolon "\\<Colon>")
    (arrowleft "\\<leftarrow>")
    (endash "\\<midarrow>")
    (arrowright "\\<rightarrow>")
    (arrowdblleft "\\<Leftarrow>")
;   (nil "\\<Midarrow>")
    (arrowdblright "\\<Rightarrow>")
    (frown "\\<frown>")
    (mapsto "\\<mapsto>")
    (leadsto "\\<leadsto>")
    (arrowup "\\<up>")
    (arrowdown "\\<down>")
    (notelement "\\<notin>")
    (multiply "\\<times>")
    (circleplus "\\<oplus>")
    (circleminus "\\<ominus>")
    (circlemultiply "\\<otimes>")
    (circleslash "\\<oslash>")
    (propersubset "\\<subset>")
    (infinity "\\<infinity>")
    (box "\\<box>")
    (lozenge1 "\\<diamond>")
    (circ "\\<circ>")
    (bullet "\\<bullet>")
    (bardbl "\\<parallel>")
    (radical "\\<surd>")
    (copyright "\\<copyright>")))

(defvar x-symbol-isabelle-xsymbol-table    ; xsymbols
  '((Xi "\\<Xi>")
    (Upsilon1 "\\<Upsilon>")
    (iota "\\<iota>")
    (upsilon "\\<upsilon>")
    (plusminus "\\<plusminus>")
    (division "\\<div>")
    (longarrowright "\\<longrightarrow>")
    (longarrowleft "\\<longleftarrow>")
    (longarrowboth "\\<longleftrightarrow>")
    (longarrowdblright "\\<Longrightarrow>")
    (longarrowdblleft "\\<Longleftarrow>")
    (longarrowdblboth "\\<Longleftrightarrow>")
    (brokenbar "\\<bar>")
    (hyphen "\\<hyphen>")
    (macron "\\<inverse>")
    (exclamdown "\\<exclamdown>")
    (questiondown "\\<questiondown>")
    (guillemotleft "\\<guillemotleft>")
    (guillemotright "\\<guillemotright>")
    (degree "\\<degree>")
    (onesuperior "\\<onesuperior>")
    (onequarter "\\<onequarter>")
    (twosuperior "\\<twosuperior>")
    (onehalf "\\<onehalf>")
    (threesuperior "\\<threesuperior>")
    (threequarters "\\<threequarters>")
    (paragraph "\\<paragraph>")
    (registered "\\<registered>")
    (ordfeminine "\\<ordfeminine>")
    (masculine "\\<ordmasculine>")
    (section "\\<section>")
    (sterling "\\<pounds>")
    (yen "\\<yen>")
    (cent "\\<cent>")
    (currency "\\<currency>")
    (braceleft2 "\\<lbrace>")
    (braceright2 "\\<rbrace>")
    (top "\\<top>")
    (congruent "\\<cong>")
    (club "\\<clubsuit>")
    (diamond "\\<diamondsuit>")
    (heart "\\<heartsuit>")
    (spade "\\<spadesuit>")
    (arrowboth "\\<leftrightarrow>")
    (greaterequal "\\<ge>")
    (proportional "\\<propto>")
    (partialdiff "\\<partial>")
    (ellipsis "\\<dots>")
    (aleph "\\<aleph>")
    (Ifraktur "\\<Im>")
    (Rfraktur "\\<Re>")
    (weierstrass "\\<wp>")
    (emptyset "\\<emptyset>")
    (angle "\\<angle>")
    (gradient "\\<nabla>")
    (product "\\<Prod>")
    (arrowdblboth "\\<Leftrightarrow>")
    (arrowdblup "\\<Up>")
    (arrowdbldown "\\<Down>")
    (angleleft "\\<langle>")
    (angleright "\\<rangle>")
    (summation "\\<Sum>")
    (integral "\\<integral>")
    (circleintegral "\\<ointegral>")
    (dagger "\\<dagger>")
    (sharp "\\<sharp>")
    (star "\\<star>")
    (smltriangleright "\\<triangleright>")
    (triangleleft "\\<lhd>")
    (triangle "\\<triangle>")
    (triangleright "\\<rhd>")
    (trianglelefteq "\\<unlhd>")
    (trianglerighteq "\\<unrhd>")
    (smltriangleleft "\\<triangleleft>")
    (natural "\\<natural>")
    (flat "\\<flat>")
    (amalg "\\<amalg>")
    (Mho "\\<mho>")
    (arrowupdown "\\<updown>")
    (longmapsto "\\<longmapsto>")
    (arrowdblupdown "\\<Updown>")
    (hookleftarrow "\\<hookleftarrow>")
    (hookrightarrow "\\<hookrightarrow>")
    (rightleftharpoons "\\<rightleftharpoons>")
    (leftharpoondown "\\<leftharpoondown>")
    (rightharpoondown "\\<rightharpoondown>")
    (leftharpoonup "\\<leftharpoonup>")
    (rightharpoonup "\\<rightharpoonup>")
    (asym "\\<asymp>")
    (minusplus "\\<minusplus>")
    (bowtie "\\<bowtie>")
    (centraldots "\\<cdots>")
    (circledot "\\<odot>")
    (propersuperset "\\<supset>")
    (reflexsuperset "\\<supseteq>")
    (propersqsuperset "\\<sqsupset>")
    (reflexsqsuperset "\\<sqsupseteq>")
    (lessless "\\<lless>")
    (greatergreater "\\<ggreater>")
    (unionplus "\\<uplus>")
    (smile "\\<smile>")
    (reflexsucc "\\<succeq>")
    (dashbar "\\<stileturn>")
    (biglogicalor "\\<Or>")
    (bigunionplus "\\<Uplus>")
    (daggerdbl "\\<ddagger>")
    (bigbowtie "\\<Join>")
    (booleans "\\<bool>")
    (complexnums "\\<complex>")
    (natnums "\\<nat>")
    (rationalnums "\\<rat>")
    (realnums "\\<real>")
    (integers "\\<int>")
    (lesssim "\\<lesssim>")
    (greatersim "\\<greatersim>")
    (lessapprox "\\<lessapprox>")
    (greaterapprox "\\<greaterapprox>")
    (definedas "\\<triangleq>")
    (cataleft "\\<lparr>")
    (cataright "\\<rparr>")
    (bigcircledot "\\<Odot>")
    (bigcirclemultiply "\\<Otimes>")
    (bigcircleplus "\\<Oplus>")
    (coproduct "\\<Coprod>")
    (cedilla "\\<cedilla>")
    (diaeresis "\\<dieresis>")
    (acute "\\<acute>")
    (hungarumlaut "\\<hungarumlaut>")
    (lozenge "\\<lozenge>")
    (smllozenge "\\<struct>")
    (dotlessi "\\<index>")
    (euro "\\<euro>")
    (zero1 "\\<zero>")
    (one1 "\\<one>")
    (two1 "\\<two>")
    (three1 "\\<three>")
    (four1 "\\<four>")
    (five1 "\\<five>")
    (six1 "\\<six>")
    (seven1 "\\<seven>")
    (eight1 "\\<eight>")
    (nine1 "\\<nine>")
    ))

(defun x-symbol-isabelle-prepare-table (table)
  "Account for differences in symbols between Isabelle/Isar and Isabelle."
  (let*
      ((is-isar (eq proof-assistant-symbol 'isar))
       (prfx1 (if is-isar "" "\\"))
       (prfx2 (if is-isar "\\" "")))
    (mapcar (lambda (entry)
              (list (car entry) nil
		    (concat prfx1 (cadr entry)) 
		    (concat prfx2 (cadr entry))))
            table)))

(defvar x-symbol-isabelle-table
  (x-symbol-isabelle-prepare-table
   (append
    x-symbol-isabelle-user-table
    x-symbol-isabelle-symbol-table
    x-symbol-isabelle-xsymbol-table)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; User-level settings for X-Symbol 
;;
;; this is MODE-ON CODING 8BITS UNIQUE SUBSCRIPTS IMAGE
(defcustom x-symbol-isabelle-auto-style
  '((proof-ass x-symbol-enable)	 ; MODE-ON: whether to turn on interactively
    nil   ;; x-symbol-coding
    'null ;; x-symbol-8bits	   [NEVER want it; null disables search]
    nil   ;; x-symbol-unique
    t     ;; x-symbol-subscripts
    nil)  ;; x-symbol-image
  "Variable used to document a language access.
See documentation of `x-symbol-auto-style'."
  :group 'x-symbol-isabelle
  :group 'x-symbol-mode
  :type 'x-symbol-auto-style)

;; FIXME da: is this needed?
(defcustom x-symbol-isabelle-auto-coding-alist nil
  "*Alist used to determine the file coding of ISABELLE buffers.
Used in the default value of `x-symbol-auto-mode-alist'.  See
variable `x-symbol-auto-coding-alist' for details."
  :group 'x-symbol-isabelle
  :group 'x-symbol-mode
  :type 'x-symbol-auto-coding)


     

(provide 'x-symbol-isabelle)
