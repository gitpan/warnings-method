/* method.xs */

#define PERL_NO_GET_CONTEXT
#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "ppport.h"

#define KEY     "method"
#define MESSAGE "Method %s::%s() called as a function"

#define WARN_METHOD warn_method

static U32 warn_method;

typedef OP* (*ck_t)(pTHX_ OP*);
static ck_t old_ck_entersub = NULL;

static OP*
method_ck_entersub(pTHX_ OP* o){
	dVAR;
	OP* kid;

	if(!ckWARN(WARN_METHOD)){
		goto end;
	}


	kid = cUNOPo->op_first;
	if(kid->op_type != OP_NULL){
		goto end;
	}

	kid = kUNOP->op_first;
	assert(kid->op_type == OP_PUSHMARK);

	while(kid->op_sibling){
		kid = kid->op_sibling;
	}

	if(kid->op_type == OP_RV2CV && (kid = kUNOP->op_first) && (kid->op_type == OP_GV)){
		GV* gv = (GV*)PAD_SV(kPADOP->op_padix);
		CV* cv;

		assert(gv != NULL);
		assert(SvTYPE(gv) == SVt_PVGV);

		if((cv = GvCV(gv)) && CvMETHOD(cv)){
			Perl_warner(aTHX_ WARN_METHOD,
				MESSAGE,
				HvNAME(GvSTASH(gv)), GvNAME(gv));
		}
	}

	end:
	return old_ck_entersub(aTHX_ o);
}

MODULE = warnings::method		PACKAGE = warnings::method

PROTOTYPES: DISABLE

BOOT:
{
	/* per-thread static storage */
	/* fetch the offset from %warnings::Offsets */
	SV* offset  = *hv_fetchs(get_hv("warnings::Offsets", TRUE), KEY, TRUE);
	WARN_METHOD = (U32)(SvUV(offset) / 2);
	/* install my ck_entersub */
	old_ck_entersub = PL_check[OP_ENTERSUB];
	PL_check[OP_ENTERSUB] = method_ck_entersub;
}

