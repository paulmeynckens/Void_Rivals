using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace FeedbackElements
{
    public class StackRepresentator : MonoBehaviour
    {
        [SerializeField] MonoBehaviour quantityChanger=null;
        [SerializeField] List<GameObject> stack = null;



        private void Awake()
        {
            if(quantityChanger is IChangeQuantity itemDepot)
            {
                itemDepot.OnChangeQuantity += ChangeStackVisual;
            }
                
            
        }



        void ChangeStackVisual(short oldQuantity, short newQuantity )
        {
            
            if (newQuantity <= stack.Count)
            {
                
                for (int i = 0; i < stack.Count; i++)
                {
                    if (i < newQuantity)
                    {
                        stack[i].SetActive(true);
                    }
                    else
                    {
                        stack[i].SetActive(false);
                    }
                }
            }
        }


    }
}

