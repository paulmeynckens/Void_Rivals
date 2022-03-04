using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CharacterLogic
{
    public class CharacterSitMode : CharacterMoveMode
    {
        Transform previousParent = null;
        Vector3 previousLocalPosition = Vector3.zero;
        Quaternion previousLocalRotation = Quaternion.identity;
        public override void Activate()
        {
            base.Activate();
            previousParent = transform.parent;
            previousLocalPosition = transform.localPosition;
            previousLocalRotation = transform.localRotation;

            
            transform.localPosition = Vector3.zero;
            transform.localRotation = Quaternion.identity;
        }

        public override void Deactivate()
        {
            base.Deactivate();
            transform.parent = previousParent;
            transform.localPosition = previousLocalPosition;
            transform.localRotation = previousLocalRotation;
        }
    }
}
