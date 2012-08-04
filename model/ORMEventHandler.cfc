component output=false implements="cfide.orm.IEventHandler" {

	public void function postNew(any entity ) {
	}


	public void function preLoad(any entity ) {
	}

	public void function preUpdate( any entity, Struct oldData ) {
		if(structKeyExists(entity, "setupdated")){
			entity.setupdated( now() );
		}
	}

	public void function preInsert(any entity ) {
		if(structKeyExists(entity, "setcreated")){
			if(!IsDate( entity.getCreated() ) ) { entity.setCreated( now() ); }
			entity.setCreated( now() );
		}

		if(structKeyExists(entity, "setupdated")){ entity.setupdated( now() ); }
	}

	public void function preDelete(any entity ) {
	}

	public void function postLoad(any entity ) {
	}

	public void function postInsert(any entity ) {
	}

	public void function postUpdate(any entity ) {
	}

	public void function postDelete(any entity ) {
	}

}