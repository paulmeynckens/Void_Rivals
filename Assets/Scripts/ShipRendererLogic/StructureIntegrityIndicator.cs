using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic.Holes;
using TMPro;


namespace ShipsRenderer
{
    public class StructureIntegrityIndicator : MonoBehaviour
    {

        [SerializeField] Structure structure = null;        
        [SerializeField] TMP_Text numberOfHolesDisplayer=null;
        [SerializeField] TMP_Text currentStructureDisplayer = null;
        [SerializeField] TMP_Text maxHealthIndicator = null;


        private void Awake()
        {
            numberOfHolesDisplayer.text = "0";
            structure.OnNumberOfholesChanged += ChangeNumberOfHolesIndication;

            maxHealthIndicator.text = "/" + structure.CurrentHealth.ToString();

            currentStructureDisplayer.text = structure.CurrentHealth.ToString();
            structure.OnChangeHealthQuantity += ChangeStructurePointsIndicator;

            
        }


        void ChangeNumberOfHolesIndication(short _old,short _new)
        {
            numberOfHolesDisplayer.text = _new.ToString();
        }

        void ChangeStructurePointsIndicator(short _old, short _new)
        {
            currentStructureDisplayer.text = _new.ToString();
        }

    }
}
