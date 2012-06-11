package arch;

import jason.RevisionFailedException;
import jason.asSemantics.ActionExec;
import jason.asSyntax.Literal;

import java.util.List;
import java.util.logging.Logger;

import cartago.Op;

import c4jason.CAgentArch;
import env.MarsEnv;

/**
 * Common architecture for the agents.
 * 
 * @author mafranko
 */
public class MarcianArch extends CAgentArch {

	protected MarsEnv env = null;

	protected Logger logger;

	public MarcianArch() {
		super();
		logger = Logger.getLogger("MarcianArch");
		env = MarsEnv.getInstance();
	}

	@Override
    public List<Literal> perceive() {
        super.perceive();
        List<Literal> eisPercepts = env.getPercepts(getAgName());
        for (Literal percept : eisPercepts) {
        	try {
				getTS().getAg().addBel(percept);
			} catch (RevisionFailedException e) {
				// e.printStackTrace();
				logger.warning("Error when adding percepts from eis to the belief base.");
			}
        }
        /*
		 * THE METHOD MUST RETURN NULL:
		 * since the percept semantics is different (event vs. state),
		 * all the the percepts from the env must be managed here, not by the BUF.
		 * 
		 * see CAgentArch.java
		 */
        return null;
    }

	@Override
	public void act(ActionExec actionExec, List<ActionExec> feedback) {
		String action = actionExec.getActionTerm().getFunctor();
		if (action.equals("skip") || action.equals("goto") || action.equals("probe")
				|| action.equals("survey") || action.equals("buy") || action.equals("recharge")) {
			boolean result = env.executeAction(this.getAgName(), actionExec.getActionTerm());
			actionExec.setResult(result);
			if (result) {
				Op op = new Op(action);
				notifyActionSuccess(op, actionExec.getActionTerm(), actionExec);
			} else {
				notifyActionFailure(actionExec, null, "Failled to performe the action: " + action);
			}
		} else {
			super.act(actionExec, feedback);
		}
	}
}