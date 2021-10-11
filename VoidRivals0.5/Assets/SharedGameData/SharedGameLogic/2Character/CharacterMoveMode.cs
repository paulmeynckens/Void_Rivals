using System.Collections;
using System.Collections.Generic;
using Core;
using Core.ServerAuthoritativeActions;
using UnityEngine;

namespace CharacterLogic
{
    public abstract class CharacterMoveMode : MonoBehaviour
    {
        
        protected TwoAxisRotator twoAxisRotator;
        public TwoAxisRotator TwoAxis
        {
            set
            {
                twoAxisRotator = value;
            }
        }
        [SerializeField] protected int layer;
        public virtual void Deactivate()
        {
            enabled = false;
        }
        public virtual void Activate()
        {
            gameObject.layer = layer;
            enabled = true;
        }
        public virtual void ModeUseInput(CharacterInput characterInput)
        {

        }

        public virtual void ModeApplyExternalForces()
        {

        }
        
    }
}
