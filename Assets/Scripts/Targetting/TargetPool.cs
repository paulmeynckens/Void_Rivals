

//#define Debug

using System.Collections;
using System.Collections.Generic;
using UnityEngine;




namespace Targetting
{
    public class TargetPool : MonoBehaviour
    {
        //instance de reference
        public static TargetPool instance;

        //pooler
        private List<Indicator> pooledObjects;

        //taille du pool, donne les ID
        private int pooledAmount = 0;

        private void Awake()
        {
            instance = this;
            pooledObjects = new List<Indicator>();
        }

        private void Start()
        {
            //pooledObjects = new List<Indicator>();
        }
        //
        /// <summary>
        ///  ajoute l'indicateur souhaité au pool et renvoie son ID a la target
        /// </summary>
        /// <param name="indicatorModel"> modele de reference à instancier</param>
        /// <returns> affecte un id a la target</returns>
        public int grow(Indicator indicatorModel)
        {
#if Debug
            Debug.Log("Instanciation");
            Debug.Log("Try to Instanciate" + indicatorModel.gameObject.name);
#endif
            Indicator newIndicator = Instantiate(indicatorModel);
#if Debug
            Debug.Log(newIndicator.gameObject.name + "instantiated");
#endif
            newIndicator.transform.SetParent(transform, false);
            newIndicator.Activate(true);
#if Debug
            Debug.Log("try to add " + newIndicator.gameObject.name + " to pooler");
#endif
            pooledObjects.Add(newIndicator);
#if Debug
            Debug.Log(newIndicator.gameObject.name + "added to pooler");
#endif
            pooledAmount++;
#if Debug
            Debug.Log("ID:" + (pooledAmount-1) + " assigné a " + newIndicator.gameObject.name);
#endif
            return pooledAmount-1;
        }

        public Indicator GetIndicator(int ID)
        {
            return pooledObjects[ID];
        }

    }
}
